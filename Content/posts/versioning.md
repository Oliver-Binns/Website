---
date: 2024-04-01 22:00
title: Versioning code with Swift
image: /Images/swift-package-manager.png
tags: Swift, Swift Package, DevOps
---

I recently created an open source Swift Package to help me automatically enforce versioning on my GitHub respositories using GitHub Actions. This post will go into detail about why versioning your code is important, how I built this to work automatically and why I chose to do this in Swift.

> prettylink https://github.com/Oliver-Binns/Versioning
> image /Images/swift-package-manager.png
> title Versioning | Oliver Binns | GitHub
> description A Swift Package for enforcing Conventional Commits and managing versions.


# Why version code?

Mobile apps becoming more complex resulting in larger codebases

Teams have been starting to look towards modular codebases in order to split up their code into manageable chunks.

Sometimes we can create packages of code that are reusable across a wide range of different apps, we often call these libraries or SDKs.

# Semantic versioning

- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

> prettylink https://semver.org
> image /Images/swift-package-manager.png
> title Semantic Versioning 2.0.0
> description "Semantic Versioning" or "SemVer" contains a set of rules and requirements that dictate how version numbers are assigned and incremented.


# Conventional commits

Conventional commits is a formal specification for commits messages that enables you to easily write automated tools for categorising commits and managing versioning.

> prettylink https://www.conventionalcommits.org/en/v1.0.0/
> image /Images/conventional-commits.jpg
> title Conventional Commits 1.0.0
> description The Conventional Commits specification is a lightweight convention on top of commit messages. It provides an easy set of rules for creating an explicit commit history; which makes it easier to write automated tools on top of. This convention dovetails with SemVer, by describing the features, fixes, and breaking changes made in commit messages.

# Swift Package Manager

I recently attended a talk by Pol Piella about writing command tools in Swift.

> youtube https://www.youtube.com/watch?v=LBYFHS8jFKk

> prettylink https://github.com/apple/swift-argument-parser
> image /Images/swift-package-manager.png
> title swift-argument-parser | Apple | GitHub
> description Straightforward, type-safe argument parsing for Swift


# GitHub Actions

https://github.com/features/actions

```swift
- name: Validate Pull Request Name
  id: versioning
  uses: Oliver-Binns/Versioning@main
  with:
    ACTION_TYPE: 'Validate'
```

```swift
- name: Increment Version
  id: versioning
  uses: Oliver-Binns/Versioning@main
  with:
    ACTION_TYPE: 'Release'
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> prettylink https://www.twitter.com/oliver-binns
> image /Images/profile-yellow.jpg
> title @Oliver_Binns | Twitter
> description The latest Tweets from @Oliver_Binns. iOS Development Craft Lead for @DeloitteDigital | Apple Alliance.
