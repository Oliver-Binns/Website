---
date: 2025-06-01 22:00
title: Managing Google Play users in Terraform
image: /Images/wearing-vision-pro.png
tags: Terraform, Google Play, Android
---

As mobile developers, we're all familiar with the Google Play Console – it’s the gateway to publishing our Android apps to millions of users.
But managing user permissions in the Play Console can quickly become a headache, especially as our teams grows and app portfolio expands.

In this post, I'll walk you through my journey of creating a [Terraform provider for Google Play Console user management](https://github.com/Oliver-Binns/terraform-provider-googleplay), which has transformed how we handle access permissions across our organisation.
Even if you've never heard of Terraform before, don't worry – this post is a beginner’s introduction into the world of mobile dev-ops!

# What is Terraform (and why should mobile developers care)?

Before we dive in, let’s address the elephant in the room: what exactly is Terraform?
Terraform is an open-source tool that allows you to define and manage your infrastructure using code.
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


## The setup 

First you’ll need to set up a new repository:

## Integrating with Google Play

As with any automated integration with Google Play, you’ll need a service account.
I won't go into details about how to manage that here because it’s been extensively covered before.
If you’re struggling, I’d recommend the official Google documentation or, failing that, [Fastlane’s Getting started with Android](https://docs.fastlane.tools/getting-started/android/setup/) guide.

Once you have this, you can set-up the provider using the `json` file, along with your 19-digit developer ID:

```tf
provider "googleplay" {
  service_account_json_base64 = filebase64("~/service-account.json")
  developer_id = "1234567890123456789"
}
```

## Declaring a user

Users are declared using a ‘resource’ in Terraform.
A resource is Terraform-speak for something that can be managed; as in: it can be created, managed and deleted once it is no longer needed.

```tf
resource "googleplay_user" "oliver" {
  email = "example@oliverbinns.co.uk"
  global_permissions = ["CAN_MANAGE_DRAFT_APPS_GLOBAL"]
}
```

## App-specific permissions

Users can be granted specific permissions to a particular app using the `googleplay_app_iam` ‘resource’.

Each App IAM resource declares:

- the email of the user who should be granted access
- the 19-digit app ID
- the set of permissions to be granted

```tf
resource "googleplay_app_iam" "test_app" {
  app_id  = "0000000000000000000"
  user_id = googleplay_user.oliver.email
  permissions = [
    "CAN_REPLY_TO_REVIEWS"
  ]
}
```

# The result

## Tying it together

something something invite email + example pull request

## Taking it further...

The great thing about Terraform is there’s a whole ecosystem of other providers that you can tie together into your Infrastructure-as-Code.
For example: there’s an [official Firebase Terraform provider](https://firebase.google.com/docs/projects/terraform/get-started) for managing projects, permissions and other resources.
You could create a role that gives your developers access to Google Play, Firebase, AWS and more with single easy change.
And even more importantly, you can ensure that access gets revoked from all these systems once it is no longer needed!!

## Get in touch

What do you think? If you found my Terraform provider useful I’d love to hear about it.
And.. if you didn’t I’d love to chat about how we can improve it to make it work for you & your team!

> prettylink https://bsky.app/profile/oliverbinns.co.uk
> image /Images/profile-yellow.jpg
> title Oliver Binns | Bluesky
> description The latest posts from Oliver Binns. iOS Development Craft Lead for @DeloitteDigital | Apple Alliance.
