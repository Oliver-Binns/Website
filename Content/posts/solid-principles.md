---
title: SOLID Principles in Swift
image: /images/wordpress-native.png
tags: iOS, Swift
---

Over the few years, I’ve been really proud of how much I’ve managed to improve as a developer. I’ve been writing code that is much cleaner and easier to maintain than ever before, and, as I always have, I look back on code that I wrote even six months ago and ask _“what on earth was I thinking?”_.

One of the main concepts that I've used to guide me on this journey are the SOLID principles. SOLID principles can help guide designs of our software, including the architecture of our apps, not just our code. They can help us to avoid code-smells and reduce the amount of rework that needs to be done when adding new features or making other changes in the future.

SOLID is an acronym which can helps to remember these five design principles:

* Single-Responsibility Principle
* Open-Closed Principle
* Liskov Substitution Principle
* Interface Segregation Principle
* Dependency Inversion Principle

These principles have been covered extensively in other articles and with details examples for a range of programming languages, including Swift. However, I’m going to try and show how we can apply them, not just to the code we write, but also the architecture of our app itself.

---

## Single-Responsibility Principle

> There should never be more than one reason for a class to change.
>
> Robert C. Martin, Design Principles and Design Patterns

### Code

### Architecture

Following the single-responsibility should not only influence how we write our code, but also the high-level architecture of our apps. As Swift Package Manager matures, many of us are moving towards writing increasingly modular code. By splitting our apps into distinct code modules, we are creating reusable packages that should each follow the single-responsibility principle.

Consider an iOS app where we have created a package which helps us to make network calls to our backend services. Now let’s imagine we have a new service that requires the user to login and then authenticate. Since our existing services don’t require this authentication, we shouldn’t add the handling of login and authentication into our networking package, but we should follow the single-responsibility principle and create a new package to handle this authentication.

---

## Open-Closed Principle

> Software entities should be open for extension, but closed for modification.
>
> Robert C. Martin, Design Principles and Design Patterns

### Code

### Architecture

---

## Interface Segregation Principle

> Many client-specific interfaces are better than one general-purpose interface.
>
> Robert C. Martin, Design Principles and Design Patterns

### Code

In Swift, an interface is known as a protocol. 

Apple recommends following a protocol-driven approach to Swift.

If you haven't watched session 408 on Protocol-Oriented Programming in Swift from WWDC15, I strongly recommend giving it a watch!

> prettylink https://developer.apple.com/videos/play/wwdc2015/408/
> title Protocol-Oriented Programming in Swift - WWDC15 - Videos - Apple Developer
> description At the heart of Swift’s design are two incredibly powerful ideas: protocol-oriented programming and first class value semantics. Each of...

### Architecture

---

## Dependency Inversion Principle

> Depend upon abstractions, [not] concretions.
>
> Robert C. Martin, Design Principles and Design Patterns

### Code

### Architecture

Again, we can apply this principle to our code modules, as well as the code itself. Consider this architecture, where we have used Amazon Web Services’ Cognito login. Now let’s say we want to move to using Microsoft’s Azure Active Directory instead, or even build our own user management system. We would have to change a lot of code in our app to do this.

If we rely on abstractions for this architecture instead, we can create wrapper modules for each of these, and then switch between them as much as we like. For example, we could easily even use different login systems for our beta testing as we do in production, or use feature flags to migrate users across.
