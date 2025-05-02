---
date: 2025-05-02 22:00
title: Managing Google Play users in Terraform
image: /Images/terraform-googleplay.png
color: #2D4686
tags: Terraform, Google Play, Android
---

As mobile developers, we’re all familiar with the Google Play Console – it’s the gateway to publishing our Android apps to millions of users.
But managing user permissions in the Play Console can quickly become a headache, especially as our teams grows and app portfolio expands.

In this post, I'll walk you through my journey of creating a [Terraform provider for Google Play Console user management](https://github.com/Oliver-Binns/terraform-provider-googleplay), which has transformed how we handle access permissions across our organisation.
Even if you've never heard of Terraform before, don't worry – this post is a beginner’s introduction into the world of mobile dev-ops!

# What is Terraform (and why should mobile developers care)?

Before we dive in, let’s address the elephant in the room: what exactly is Terraform?
Terraform is an open-source tool that allows you to define and manage your infrastructure using code.
It’s a declarative language, so the style is similar to Jetpack Compose and SwiftUI.
Infrastructure-as-Code (IaC) has traditionally been used by DevOps teams to provision cloud resources like servers and databases.
However, its principles can be applied to any API-driven service – including the Google Play Console.

Managing resources (or user access using IaC) has several _key_ benefits:
- Consistency: Define your team's access permissions once, and apply them consistently across multiple projects
- Version control: Track changes to your permission structures over time with git
- Safety: Define main roles separately from onboarding users and enforce reviews before access can be granted
- Documentation: Self-documenting code that shows exactly who has what permissions

Put simply, Terraform lets you replace manual clicking ("click-ops") through the Google Play Console UI with code that automatically handles user management for you.

# How to use it

My unofficial Terraform provider for managing Google Play permissions is now available on the Terraform registry.
If you’re interested, I’m planning talk a lot more about how I built this - and some of the challenges I faced - in a future blog post.

> prettylink https://github.com/Oliver-Binns/terraform-provider-googleplay
> image /Images/github-terraform-googleplay.png
> title Terraform Provider for Google Play Console
> description Terraform Provider for managing user permissions in Google Play Console.

## The setup 

First you’ll need to install Terraform.
I found this easiest using Homebrew, but the [official guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) will always contain the latest guidance on how to achieve this.
```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Once this is done, you can create a main file `main.tf` and start writing your Terraform code!
Since we’re wanting to manage Google Play permissions, we’ll want to import my [community provider from the Terraform registry](https://registry.terraform.io/providers/Oliver-Binns/googleplay/latest).

```hcl
terraform {
  required_providers {
    googleplay = {
      source  = "Oliver-Binns/googleplay"
      version = "~> 0.4.3"
    }
  }

  required_version = ">= 1.2.0"
}

```

Then we can run the `init` command to ensure that the provider gets downloaded correctly.

```sh
terraform init
```

## Integrating with Google Play

As with any automated integration with Google Play, you’ll need a service account.
I won't go into details about how to manage that here because it’s been extensively covered before.
If you’re struggling, I’d recommend the official Google documentation or, failing that, [Fastlane’s Getting started with Android](https://docs.fastlane.tools/getting-started/android/setup/) guide.

Once you have this, you can set-up the provider using the `json` file, along with your 19-digit developer ID:

```hcl
provider "googleplay" {
  service_account_json_base64 = filebase64("~/service-account.json")
  developer_id = "1234567890123456789"
}
```

## Declaring a user

Users are declared using a ‘resource’ in Terraform.
A resource is Terraform-speak for something that can be managed; as in: it can be created, managed and deleted once it is no longer needed.

```hcl
resource "googleplay_user" "oliver" {
  email = "example@oliverbinns.co.uk"
  global_permissions = ["CAN_MANAGE_DRAFT_APPS_GLOBAL"]
}
```

The permissions here are at user level and would give the user these permissions over all apps in the developer account.
The possible values you can specify are specified in the [Google Play Developer API documentation](https://developers.google.com/android-publisher/api-ref/rest/v3/users).

As it’s not possible to create a user with no permissions, this value cannot be empty.

If you run `terraform plan` it will tell you the actions it *wants* to take to sync your resources:

```sh
oliver@Olivers-MacBook-Air personal-infra % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # googleplay_user.abc will be created
  + resource "googleplay_user" "oliver" {
      + email                = "example@oliverbinns.co.uk"
      + expanded_permissions = (known after apply)
      + global_permissions   = [
          + "CAN_MANAGE_DRAFT_APPS_GLOBAL",
        ]
      + name                 = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

If you’re happy with this, you can run `terraform apply` to *make* the changes:

```sh
oliver@Olivers-MacBook-Air personal-infra % terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # googleplay_user.example will be updated in-place
  + resource "googleplay_user" "example" {
      + email                = "example@oliverbinns.co.uk"
      + expanded_permissions = (known after apply)
      + global_permissions   = [
          + "CAN_MANAGE_DRAFT_APPS_GLOBAL",
        ]
      + name                 = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

googleplay_user.example: Modifying... [name=developers/5166846112789481453/users/example@oliverbinns.co.uk]
googleplay_user.example: Modifications complete after 1s [name=developers/5166846112789481453/users/example@oliverbinns.co.uk]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## App-specific permissions

Users can also be granted specific permissions to a particular app using the `googleplay_app_iam` ‘resource’.

Each App IAM resource declares:

- the email of the user who should be granted access
- the 19-digit app ID
- the set of permissions to be granted

```hcl
resource "googleplay_app_iam" "test_app" {
  app_id  = "0000000000000000000"
  user_id = googleplay_user.oliver.email
  permissions = [
    "CAN_REPLY_TO_REVIEWS"
  ]
}
```

Again, you can find the possible values for permissions in the [Google Play Developer API documentation](https://developers.google.com/android-publisher/api-ref/rest/v3/grants#applevelpermission).

## Running on the CI

Some of the main advantages of Infrastructure-as-Code only apply once we start managing our code using version control. In particular — as I mentioned in the introduction — being able to see changes to permissions over time, being able to enforce peer reviews on changes, and being able to prevent mistakes using automated builds: the same way as we do with _any_ of our code.

The first two of these are trivial if you’ve used version control (such as Git) before. There are [many articles covering this](https://docs.github.com/en/get-started/start-your-journey/about-github-and-git) already, so I’m going to assume you’re familiar with GitHub and GitHub Actions already, and skip straight to automating the builds.

> prettylink https://docs.github.com/en/get-started/start-your-journey/about-github-and-git
> image /Images/github-docs.png
> title About GitHub and Git - GitHub Docs
> description Get started with GitHub and Git. GitHub is a collaborative platform that enables version control and team collaboration on software projects.

The first step is to install Terraform on the build agent. Luckily this is easy using GitHub Actions with the [first-party setup-terraform action](https://github.com/hashicorp/setup-terraform) from Hashicorp:

```yml
jobs:
  apply:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
```

When declaring our Terraform provider for Google Play, we’ll want to  handle the `service-account.json` file safely as it is secret and can be used to access our account!
On GitHub Actions, be sure to save the file information as a [secret](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions), rather than checking it into the repository.

We also need to know about more about how Terraform tracks the state of the resources it is managing. When we ran the plan and apply commands locally, Terraform will have created a `terraform.tfstate` file which contains all the information about our resources. As this file will potentially contain sensitive information, we **don’t** want to check this in with the rest of our code. There are a few ways to handle this. When managing cloud resources, the standard pattern is to store it in that cloud (such as AWS S3). As we’re not doing that here, another option is to use [Terraform Cloud Platform](https://www.hashicorp.com/en/products/terraform): this is even [**free** for a small number of resources](https://www.hashicorp.com/en/pricing). 

There are multiple ways to achieve this, but I [created a new workspace](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/create#create-a-workspace) using the Web UI, set it to use [local execution](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/create#create-a-workspace) (so it *runs* in GitHub Actions rather than on Terraform Cloud), then [created a user token](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens) to allow GitHub Actions to call it. You can provide this to Terraform using an environment variable:

```yml
env:
  TF_CLOUD_ORGANIZATION: "oliver-binns"
  TF_TOKEN_app_terraform_io: "${{ secrets.TF_API_TOKEN }}"
  TF_WORKSPACE: "prod"
```

We should now be able to run our `init`, `plan` and `apply` steps easily on GitHub Actions. You’ll probably want to run `plan` on pull requests and `apply` once the request has been approved and merged.
```yml
- name: Terraform Init
  id: init
  run: terraform init -input=false

- name: Terraform Apply
  id: apply
  run: terraform apply -no-color -input=false
```

When running plan on the pull request, you can [use GitHub script](https://github.com/hashicorp/setup-terraform) to comment the plan, so that it's easy for others to peer review the changes that you've made.

# The result

## Tying it together

You can see this all working in the [public GitHub repo](https://github.com/Oliver-Binns/personal-infra) I now use for managing permissions on my own account.

It can be used for inviting new users to the Play Console:

![Invite email for the Google Play Console](../../Images/googleplay-invite.png)

And it runs GitHub Actions for any changes, you can just take a look at some [previous pull requests](https://github.com/Oliver-Binns/personal-infra/pull/3) to see the `terraform plan` output commented by the GitHub Actions bot.

In the future, I’d love to expand the provider to include management of other functionality within the Google Play Console, such as apps and testing tracks.


> prettylink https://github.com/Oliver-Binns/personal-infra
> image /Images/github-infra.png
> title personal-infra
> description A repository for managing infrastructure related to my personal projects using code.

## Taking it further...

The great thing about Terraform is there’s a whole ecosystem of other providers that you can tie together into your Infrastructure-as-Code.
For example: there’s an [official Firebase Terraform provider](https://firebase.google.com/docs/projects/terraform/get-started) for managing projects, permissions and other resources.
You could create a role that gives your developers access to Google Play, Firebase, GitHub, AWS and more with single easy change.
And even more importantly, you can ensure that access gets revoked from all these systems once it is no longer needed!!

## Get in touch

What do you think? If you found my Terraform provider useful I’d love to hear about it.


And.. if you didn’t I’d love to chat about how we can improve it to make it work for you & your team!

> prettylink https://bsky.app/profile/oliverbinns.co.uk
> image /Images/profile-yellow.jpg
> title Oliver Binns | Bluesky
> description The latest posts from Oliver Binns, Lead Mobile Developer @ Deloitte Digital. Finalist for Engineer of the Year @ UK IT Industry Awards 2024
