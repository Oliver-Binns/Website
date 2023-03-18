---
title: A case for native mobile apps
image: /images/wordpress-native.png
tags: iOS, Swift
---

## Web vs Mobile

When deciding whether to build a mobile app, the first question that is usually asked first is what kind of app to build. The three options on the table are web app, cross-platform app or native app. Usually this is best taken as two separate decisions; web or mobile, then cross-platform or native.

Websites have the advantage of scale: they are available across iOS and Android, but can also be used on desktop and so many other devices too. As I mentioned in a previous post, “there’s no shame in delivering great content through the web”. Indeed, where possible, I’d generally recommend a web-first approach for maximising your user base.

## When to go Mobile

When you want to start creating richer user experiences, it’s best to create a mobile app. Think of the features that you want from any app: push notifications, camera usage including augmented reality, audio streaming and more. These all work far better when implemented as part of a mobile app.

User Experience, Performance, Security

Always there: quick to open. Download adds a barrier to entry; app clips are a middle ground here.

## Cross-Platform

A great deal of fuss has been made online over the last couple of years about Flutter. I’ve seen claims that there is no reason to build native apps anymore because it will allow cross-platform apps to be built easily for most use-cases. When I see these, I can‘t help but think of the same claims that were made when React Native was first gaining traction- nearly seven years ago.

Risk of vendors dropping support- while this may not immediately kill your apps, they will likely gradually start feeling old and you will fall behind the curve.

I’ve heard arguments that many of these are open source and you can write your own extensions. But if you’re using these solutions to save time, do you really expect to take on ownership of a community tool too? The only solutions that have an incentive to keep updating are Android Studio and Xcode.

Sometimes cross-platform can be the right choice: when you need to enter the market quickly building a simple app that doesn’t require many native features. From AirBnB’s journey, we can see a clear progression: start with web for maximum impact, move to cross-platform for a quicker journey into mobile allowing growth to continue at pace, use this growth to transition to native providing the world-class user experience that users (and our developers!) expect.

Like most choices, there is no “better” in cross-platform vs native. It’s simply which is the best tool for your current task.

## Native Best Practices

Move heavy business logic to the server

Re-use: code across and within apps

## Build Once?

Client apps should be lightweight

Bridging code or platform specific will need writing twice anyway
