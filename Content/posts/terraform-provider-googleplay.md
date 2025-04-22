---
date: 2025-06-01 22:00
title: Managing Google Play users in Terraform
image: /Images/wearing-vision-pro.png
tags: Terraform, Google Play, Android
---

As mobile developers, we're all familiar with the Google Play Console – it's the gateway to publishing our Android apps to millions of users.
But managing user permissions in the Play Console can quickly become a headache, especially as our teams grows and app portfolio expands.

In this post, I'll walk you through my journey of creating a [Terraform provider for Google Play Console user management](https://github.com/Oliver-Binns/terraform-provider-googleplay), which has transformed how we handle access permissions across our organisation.
Even if you've never heard of Terraform before, don't worry – this post is a beginner’s introduction into the world of mobile dev-ops!

# What is Terraform (and why should mobile developers care)?

Before we dive in, let's address the elephant in the room: what exactly is Terraform?
Terraform is an open-source tool that allows you to define and manage your infrastructure using code.
Infrastructure-as-Code (IaC) has traditionally been used by DevOps teams to provision cloud resources like servers and databases.
However, its principles can be applied to any API-driven service – including the Google Play Console.

Managing resources (or user access using IaC) has several _key_ benefits:
- Consistency: Define your team's access permissions once, and apply them consistently across multiple projects
- Version control: Track changes to your permission structures over time with git
- Safety: Define main roles separately from onboarding users and enforce reviews before access can be granted
- Documentation: Self-documenting code that shows exactly who has what permissions

Put simply, Terraform lets you replace manual clicking ("click-ops") through the Google Play Console UI with code that automatically handles user management for you.

