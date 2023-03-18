---
date: 2021-04-28 09:45
title: Gitflow with Automation for Mobile Apps
image: /images/git-flow.jpg
tags: iOS, Swift
---

## Gitflow Workflow

Gitflow is a great branching strategy for mobile apps. As mobile developers we can only publish one stable release through the App Store and Google Play Store, therefore we do not need to—nor are we able to—ship bug fixes for older intermediate versions of the software.

> prettylink https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
> image /images/gitflow.svg
> title Gitflow Workflow | Atlassian Git Tutorial
> description A deep dive into the Gitflow Workflow. Learn if this Git workflow is right for you and your team with this comprehensive tutorial.

## Automation

Automation is essential for achieving our agile principle of delivering working software frequently. Automated code-gates on our repository are like the brakes on our car, without them we cannot move faster without fear of crashing. Other parts of our automation, such as deployment, are more like the auto-pilot on an aeroplane; they do all the heavy lifting once a merge is complete.

> _Deliver working software frequently, from a couple of weeks to a couple of months, with a preference to the shorter timescale._

> _— Principles behind the Agile Manifesto, [agilemanifesto.org](http://agilemanifesto.org/principles.html)_

## Adapting Gitflow for Automation

One limitation I’ve found with Gitflow, is that it assumes fixes to a release will be committed directly to the release branch. However this does not allow us to code-review changes and use the same automated code-gates as with any of our other changes. I propose a new branch type for this purpose which we’ll call _bugfix_. I’ve seen [arguments that a feature branch should be used for this](https://softwareengineering.stackexchange.com/questions/307360/where-do-bugfixes-go-in-the-git-flow-model), however I think that adds some ambiguity and defeats the aim of branch prefixes: identifying where this branch should eventually merge to.

Therefore the slight adaptation of GitFlow I’ve been using works like this:

* _main_ tracks the current live or pending App Review release
    * _hotfix_ taken from and merged to _main_
* _release_ taken from _develop_, merged to _main_
    * _bugfix_ taken from and merged to _release_
* _develop_ contains the latest and greatest changes to the codebase
    * _feature_ taken from and merged to _develop_

## Automating Code Gates

We can set up a whole automation pipeline around this approach where a number of gates, both manual and automated must be opened before a developer is allowed to merge code. There is a balance that needs to be struck to ensure quality without triggering developer frustration at a bar which is too high. I think [this documentation from Google’s Engineering Practices](https://google.github.io/eng-practices/review/reviewer/standard.html) does a great job at defining a compromise between perfection and progress for code review in particular, but the principles can also be applied to automated gates too.

> prettylink https://google.github.io/eng-practices/review/reviewer/
> image /images/google.png
> title How to do a code review
> description Google’s Engineering Practices documentation

There are a number of automated gates that you should consider adding to your branches. These vary from basic linting through to full automated end-to-end integration tests. Some of these are free, so you can get started straight away, but some come at a high price, so you’ll have to consider if they’re worth it for your project.

While some CI/CD providers, such as Bitrise, have a great setup process with drag and drop components, I recommend using Fastlane directly for setting up automation scripts because it can be executed on any of these and even locally as required.

## Before a change...

Merging to a stable branch, such as develop, release/vX-X-X or main, should be done via a pull-request. This allows us to guarantee it remains stable.

As well as a code review, we can also run:

* the linter for our language: [SwiftLint](https://github.com/realm/SwiftLint) for Swift, [ktlint](https://github.com/pinterest/ktlint) for Kotlin, etc. to enforce a uniform code-style
* unit tests to catch regressions in low-level code behaviour
* UI tests to catch regressions in whole user journeys

We can add additional tools and checks as required. I’ve had a lot of luck using [SonarQube](https://www.sonarqube.org/) to enforce a high level of test coverage, no code duplication and catch code-smells and bugs. On solo projects, [Amazon CodeGuru](https://aws.amazon.com/codeguru/) might be a good alternative to manual code review, or you could even use it to complement your existing manual review.

## After a change...

After we merge a pull request, we should build a binary of our application. Depending on which branch we merge to this build can perform a different purpose. For `develop` merges, this can be used for internal validation within the team by designers, product owners and anyone else with an interest in the change. For `release` merges, these can be used for a full QA cycle including various forms of manual and automated testing. For `main` merges, this is the final build which can then be used for pre-deployment testing before being released to users. At this point we may also want to generate screenshots for our App Store listing and any metadata, including credentials for App Review.

![A diagram showing GitFlow branching with automated gates at each merge step.](/images/gitflow-full-automation.png)

_The full automated Continuous Integration & Deployment Pipeline_


## Tips & Tricks

### Small Changes

As developers we should aim to ensure each of our changes are as small as possible. This helps reduce the burden of code-review on the other members of our team, but also reduces that chance that a bug sneaks into our code. Releasing small changes regularly can also reduce the confusion for users as they update to new versions of our app.

### Feature Flags

It can be hard to merge small discrete changes when working on larger features, but it’s possible using Feature Flags. These allow functionality to be enabled for testing but disabled in production. It’s also a great way to A/B test features in production and eventually triggering them on, with a fallback in place.

### Get in touch

What do you think? I’d love to hear how you approach branching and automation in your team or for your side-projects and whether you’ve found any of these processes useful in your work.

> prettylink https://www.twitter.com/oliver-binns
> image /images/profile-yellow.jpg
> title @Oliver_Binns | Twitter
> description The latest Tweets from @Oliver_Binns. iOS Development Craft Lead for @DeloitteDigital | Apple Alliance.

