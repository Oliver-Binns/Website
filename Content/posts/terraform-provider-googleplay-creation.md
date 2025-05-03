---
date: 2025-06-14 22:00
title: Creating a Google Play Terraform provider
image: /Images/terraform-googleplay-post2.png
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

> prettylink https://github.com/Oliver-Binns/personal-infra
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

# 1. Interfacing with the Google Play API

Go
[Google Play Android Developer API](https://developers.google.com/android-publisher/api-ref/rest)

## Challenge 1: Limited APIs

Google Play don't offering filtering on their list user API so you have to grab the full list each time

## Challenge 2 - Part 1: Nested permissions

Google Play permissions are nested - they have global and app specific ones

You can’t create a new user with zero permissions: so every user must have at least one global permission because you can’t create app specific permissions at the same time you create a user


# 2. The Terraform provider

The Terraform provider repository is created from Hashicorp‘s [quick start template](https://github.com/hashicorp/terraform-provider-scaffolding-framework). 

## Challenge 2 - Part 2: Nested schema

## Challenge 2 - Part 3: Zero permissions strikes again

Terraform is declarative, and is designed to be redeployable.
The new state should be reachable from both _new_ and _existing_ states: is this possible?

## Challenge 3: Implicit additional permissions

Permissions have implicit inheritance of additional permissions that then get returned from the API and cause Terraform to panic

# 3. The reference implementation

Terraform - at last!

You’ve seen this before - it's the previous article.


# The result

## Get in touch

What do you think? If you found my Terraform provider useful I’d love to hear about it.
And.. if you didn’t I’d love to chat about how we can improve it to make it work for you & your team!

> prettylink https://bsky.app/profile/oliverbinns.co.uk
> image /Images/profile-yellow.jpg
> title Oliver Binns | Bluesky
> description The latest posts from Oliver Binns. iOS Development Craft Lead for @DeloitteDigital | Apple Alliance.
