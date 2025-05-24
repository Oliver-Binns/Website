---
date: 2025-05-24 14:00
title: Creating a Google Play Terraform provider
image: /Images/terraform-googleplay-post2.png
color: #2D3361
tags: Terraform, Google Play, Android
---

Recently I posted about my open-source community Terraform provider for managing permissions on the Google Play Console.
In that article, I explained the benefits of Infrastructure-as-Code for administering a range of cloud resources and how it can be useful to us as mobile developers.
I *also* promised to talk more about how I achieved it, so here is the full story explaning the challenges I faced, decisions I took, and things I’d love to improve with time - and support from Google.

Quick disclaimer: I’m an experienced mobile developer dabbling in Terraform, not an SRE expert, so while this solution works well for me, it may not always follow language conventions and best practices.

> prettylink /posts/terraform-provider-googleplay
> image /Images/terraform-googleplay.png
> title Managing Google Play users in Terraform
> description In this article, I will introduce a Terraform provider to manage Google Play Console users, enabling automated, scalable, and consistent user permission handling for mobile development teams through Infrastructure-as-Code.

# The overall architecture

The provider and sample code itself comes in the form of three repositories:

> prettylink https://github.com/Oliver-Binns/googleplay-go
> image /Images/googleplay-go.png
> title Google Play Console Go Client Integration
> description The interface with the Google Play Developer API, written in Go, implements API calls to the Google Play Android Developer API

> prettylink https://github.com/Oliver-Binns/terraform-provider-googleplay
> image /Images/github-terraform-googleplay.png
> title Terraform Provider for Google Play Console
> description The Terraform provider itself, this defines the Terraform schema and calls the Google Play Go interface to make changes based on the Terraform code

> prettylink https://github.com/Oliver-Binns/personal-infra
> image /Images/github-infra.png
> title personal-infra
> description A reference implementation which shows the provider being used to manage users within my own Google Play Account

# Interfacing with the Google Play API

Firstly, I needed to build code that would allow the Terraform provider to integrate with Google Play to manage users.

## Tooling

Integrating with Google Play is done through the [Google Play Android Developer API](https://developers.google.com/android-publisher/api-ref/rest).
Since Terraform providers are generally build in Go, it made the most sense to build the API integration in Go too.
I used [Visual Studio Code](https://code.visualstudio.com), and found the [GitHub Co-Pilot](https://github.com/features/copilot) extension particularly useful for helping me adapt to the quirks of a new language.
I also use [Claude](https://claude.ai) for more easily digesting large pieces of documentation quickly.

## Authenticating

Authentication to the API is via a Google Cloud Service Account.
Clients must use the private key for the account to sign JWTs which can be exchanged by the [Google Authorization Service](https://developers.google.com/identity/protocols/oauth2) for API bearer tokens.
This is the OAuth 2.0 client credentials flow.

I used the open-source [golang-jwt](https://github.com/golang-jwt/jwt) library for creating the JWT using the service account private key. The scopes, audience and other values are defined across [Google’s documentation](https://developers.google.com/identity/protocols/oauth2/scopes#androidpublisher), it took me a bit of digging to find _everything_ I needed here:

```go
token := jwt.NewWithClaims(jwt.SigningMethodRS256, jwt.MapClaims{
    "iss":   ts.account.ClientEmail,
    "sub":   ts.account.ClientEmail,
    "scope": "https://www.googleapis.com/auth/androidpublisher",
    "aud":   "https://oauth2.googleapis.com/token",
    "iat":   iat.Unix(),
    "exp":   exp.Unix(),
})
token.Header["alg"] = "RS256"
token.Header["typ"] = "JWT"
token.Header["kid"] = ts.account.PrivateKeyID

bearer, err := token.SignedString(ts.pk)
```

We provide this JWT as an assertion in the token exchange request to the authorization server:

```go
// Encode the request:
tokenExchangeRequest := tokenExchangeRequest{
    GrantType: "urn:ietf:params:oauth:grant-type:jwt-bearer",
    Assertion: token,
}
body := bytes.NewBuffer(nil)
_ := json.NewEncoder(body).Encode(tokenExchangeRequest)

// Call the Authorization Server:
url := "https://www.googleapis.com/oauth2/v4/token"
req, _ := http.NewRequestWithContext(t.context, http.MethodPost, url, body)
req.Header.Set("Content-Type", "application/json")
resp, _ := t.httpClient.Do(req)
```

`resp` is a JSON object containing a standard access token response, that we can use to make authorised requests to the Google Play Android Developer API.

## Challenge 1: Limited APIs

**TLDR; Everything I needed is available, but not always in the form I wanted or expected.**

Since we’re now in a position where we can make successful API calls, it’s time to talk about the first major limitation I faced in this project: the limited range of APIs that are available.
It seems to me that the Google Play Console team have only created the APIs that they *needed* to make Web UI and then made those public, rather than building out a full set of APIs.

Google Play Console has three mechanisms for managing user permissions: 

- [Developer Level Permissions](https://developers.google.com/android-publisher/api-ref/rest/v3/users#DeveloperLevelPermission) (global for *all* apps in the account) 
- [App Level Permissions](https://developers.google.com/android-publisher/api-ref/rest/v3/grants#Grant.AppLevelPermission) (for a specific package ID)
- [Permission Groups](https://android-developers.googleblog.com/2021/09/improved-google-play-console-user.html) (access inherited from a named group)

It seems that only the first two of these are available to use via an API.
That’s mostly ok because we can define our groups in Terraform anyway, but it means we couldn’t easily share groups between Terraform and click-ops.

### Users & Developer Level Permissions

When managing users, there are APIs for [create, update, delete and list](https://developers.google.com/android-publisher/api-ref/rest/v3/users).
Unfortunately there is no mechanism for filtering the list API and no API available for fetching a specific user by their ID.
This means if you want to fetch a specific user on-demand, you need to fetch the whole list of users and then search through it for the one you’re looking for - not very efficient!

Developer Level Permissions are an attribute of a user, so we can use the create, update and delete APIs to set this permission.
Frustratingly, users created with the API must have *some* permission(s), and app specific permissions **cannot** be set when creating a user.
This means (as far as I can tell) it‘s impossible to manage users with *only* App Level Permissions.

### Grants & App Level Permissions

Grants are a mapping between a user, a set of App Level Permissions and a Google Play App ID.

```json
{
  "name": string,
  "packageName": string,
  "appLevelPermissions": [
    enum (AppLevelPermission)
  ]
}
```

To create, update or delete a Grant, we must use the [Grant resource API](https://developers.google.com/android-publisher/api-ref/rest/v3/grants).
However, there is no API for reading the state of a Grant or even listing Grants.
To get the state, we must access them via the same User resource API as with Developer Level Permissions.
As mentioned about, the User API has no filtering functionality, so we must retrieve the state of *all* users and *all* grants and filter them ourselves - again: not very efficient!

# The Terraform provider

The Terraform provider repository is created from Hashicorp‘s [quick start template](https://github.com/hashicorp/terraform-provider-scaffolding-framework).
The template was particularly useful to understand how the provider should be structured.
I also used this similar [App Store Terraform provider](https://github.com/alexprogrammr/terraform-provider-appstore) by Oleksandr Chaikovskyi as inspiration.

As I mentioned above, the provider is written in Go.
The tooling I used for creating this repository is the same as for Google Play Developer API integration.

## Core concepts

There are three main concepts that we need to understand to build a Terraform provider:

- A provider enables communication with external APIs and services
- A resource is anything that is managed (created, modified, deleted) by Terraform.
- A data source is anything that can be _read_ by Terraform.

### Provider

The provider itself is a type which is configured with a model.
Since everything we need in this implementation can be modified, so we only care about the provider and resource.
The create the type we must implement several methods:

- Metadata: names and versioning for the provider
- Schema: the schema for our Terraform code
- Configure: a method that takes the provider model from Terraform and configures input data for resources and data sources written in Go
- Resources: any resources we will allow to be managed (user permissions, app permissions)
- Data Sources: any data sources we will provide (none!)
- Functions: any transformation functions we provide (none!)

### Resources

Our resources follow a similar pattern:

- Metadata: the name of our resource
- Schema: the schema for our Terraform code
- Configure: a method that takes the provider model from Terraform and configures input data for resources and data sources written in Go

but then deviate, with methods for Validate, Create, Read, Update and Delete ([CRUD!](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)).

### Schema

Our schema is the contract between our provider and the Terraform code that we’ll use to manage users in Google Play.
It declares the shape and properties that consumers of our provider must provide in order for the users to be created.

Our provider schema states that the consumer should provide a valid base-64 encoded service account json file and their 19-digit Google Play Developer account ID. Both of these are marked as required attributes meaning that they must be provided. The service account configuration is marked as sensitive to ensure it does not get printed to the console.

```go
resp.Schema = schema.Schema{
  Description: "Interact with Google Play Console",
  Attributes: map[string]schema.Attribute{
    "service_account_json_base64": schema.StringAttribute{
      MarkdownDescription: `The service account JSON data used to authenticate with Google:
      https://developers.google.com/android-publisher/getting_started#service-account`,
      Required:  true,
      Sensitive: true,
    },
    "developer_id": schema.StringAttribute{
      MarkdownDescription: `Your unique 19-digit Google Play Developer account ID:
      https://support.google.com/googleplay/android-developer/answer/13634081?hl=en-GB`,
      Required:  true,
      Sensitive: false,
    },
  },
}
```

This is mapped into a data model which get provided with when writing our `Configure` method:

```go
type GooglePlayProviderModel struct {
  ServiceAccountJson types.String `tfsdk:"service_account_json_base64"`
  DeveloperID        types.String `tfsdk:"developer_id"`
}
```

You can see how Go creates this model from the Terraform configuration that we provide:

```hcl
provider "googleplay" {
  service_account_json_base64 = filebase64("~/service-account.json")
  developer_id = "1234567890123456789"
}
```

The Kotlin equivalent of this model would be something like this:

```kt
data class GooglePlayProviderModel(
  val serviceAccountJson: String,
  val developerId: String,
)
```

While the `Configure` method signature may seem a bit strange to begin with, it’s basically just an initaliser that sets up the `GooglePlayProvider` project which is passed in:

```go
func (p *GooglePlayProvider) Configure(
  ctx context.Context, 
  req provider.ConfigureRequest, 
  resp *provider.ConfigureResponse
)
```

So the equivalent in Kotlin might look like:

```kt
class GooglePlayProvider(
  ctx Context, 
  req: ConfigureRequest,
  resp: ConfigureResponse,
)
```

## Challenge 2: Nested schema

As I mentioned above, there are two related types of permission that can be managed with this provider: developer level permissions and app level permissions.
Since app level permissions must be granted to a specific developer, they are effectively nested inside the developer level resource.

I considered two approaches to this.
The first was to create a nesting within the user resource object:

```hcl
resource "googleplay_user" "oliver" {
  email = "example@oliverbinns.co.uk"
  global_permissions = ["CAN_MANAGE_DRAFT_APPS_GLOBAL"]
  app_permissions = [{
    app_id  = "0000000000000000000"
    permissions = [
      "CAN_REPLY_TO_REVIEWS"
    ]
  }]
}
```

However, in the end, I decided to implement the app level permissions as a separate resource type.
Implementing the nested permissions was simple enough for creation and deletion, but would mean manually implementing the diffing between the nested objects.
When implementing this as separate resources, Terraform does this automatically.
As well as being easier to implement, this also felt more in keeping with Terraform conventions.

```hcl
resource "googleplay_app_iam" "test_app" {
  app_id  = "0000000000000000000"
  user_id = googleplay_user.oliver.email
  permissions = [
    "CAN_REPLY_TO_REVIEWS"
  ]
}
```

Terraform automatically manages dependencies between objects, so if you add both a new user and app-level permission linked with the user ID like the example above, then it will create the user first and then add the app permission.

## Challenge 3: Implicit additional permissions

Terraform tracks the changes that it makes and asserts that change it makes were made successfully.
However, the Google Play Console implicitly adds additional lower-ranking permissions when adding more powerful permissions.
These additional permissions are then returned from the API and causes Terraform to throw errors that the change had unexpected side-effects.
For example: when setting the developer level permission to `["CAN_MANAGE_PUBLIC_LISTING"]` the permissions are _actually_ set to: `["CAN_MANAGE_PUBLIC_LISTING", "CAN_VIEW_NON_FINANCIAL_DATA", "CAN_VIEW_APP_QUALITY"]`.


Unfortunately, this behaviour doesn’t appear to be documented so I had to discover each manually.
Moreover, the behaviour does not appear to be entirely consistent between the developer level and app level permissions.
This may cause issues in the future if Google change this undocumented behaviour without notice.

In order to work around this, I had to manually map the behaviours in Go.
I then added a computed property (`expanded_permissions`) to the Terraform schema.
The `permissions` that the user declares is mapped to this computed property, so that Terraform always sets (and therefore expects) the full list of permissions:

```go
"expanded_permissions": schema.SetAttribute{
  MarkdownDescription: `Permissions for the user which apply to this specific app:
  https://developers.google.com/android-publisher/api-ref/rest/v3/grants#applevelpermission`,
  ElementType: types.StringType,
  Computed:    true,
  PlanModifiers: []planmodifier.Set{
    expandUserPermissionsPlanModifier(path.Root("global_permissions")),
  },
},
```

For the full implementation, see the [pull request on GitHub](https://github.com/Oliver-Binns/terraform-provider-googleplay/pull/26/files).

# The result: a reference implementation

Some Terraform - at last! You’ve probably seen this before - it’s in my [previous article](../terraform-provider-googleplay):

```hcl
resource "googleplay_user" "oliver" {
  email = "example@oliverbinns.co.uk"
  global_permissions = ["CAN_MANAGE_DRAFT_APPS_GLOBAL"]
}
```

I use the reference implementation to manage permissions to my own personal Google Play account.

## Get in touch

What do you think? If you found my Terraform provider useful I’d love to hear about it.


And.. if you didn’t I’d love to chat about how we can improve it to make it work for you & your team!

> prettylink https://bsky.app/profile/oliverbinns.co.uk
> image /Images/profile-yellow.jpg
> title Oliver Binns | Bluesky
> description The latest posts from Oliver Binns. iOS Development Craft Lead for @DeloitteDigital | Apple Alliance.
