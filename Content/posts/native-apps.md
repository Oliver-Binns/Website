---
title: A case for native mobile apps
image: /images/native-tooling.png
tags: iOS, Swift
---

## So you want to build an app?

When deciding whether to build a mobile app, the first question that is usually asked first is what kind of app to build.
The three options on the table are usually website, cross-platform app or native app.


In my experience, this is best taken as two separate decisions; web or mobile, then cross-platform or native.


## Web vs Mobile

Websites have the advantage of scale: they are available across iOS and Android, but can also be used on desktop and so many other devices too.
As I mentioned in a previous post, “there’s no shame in delivering great content through the web”.
Indeed, where possible, I’d generally recommend a web-first approach for maximising your user base.

_mobile opens a whole set of other challenges_
- code must run on a user’s device, so you have a different security profile
- you deal with Apple and Google’s controlling presence
- user’s expect things to work offline

> prettylink https://jacobbartlett.substack.com/p/mobile-is-actually-pretty-hard
> image /images/jacob.jpg
> title Mobile is actually pretty hard.
> description You might picture mobile engineers as blissfully unaware drones, making castles in the sandbox provided to us by our favoured tech giant, tongues lolling and eyes glazing over while we wait 30 minutes for Xcode to build. But hold onto your FitBits, naysayers. I’m about to shatter the illusion that mobile development is a walk in the (Apple) Park.

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

## The Airbnb Story: A Case Study

Airbnb’s journey is a great illustration of how to efficiently use the resources at your disposal to gradually improve user experience as you grow your business.
Airbnb was founded in 2007, only one month after the launch of the App Store and two months before the launch of Google Play (then named Android Market).
Smartphones were in their infancy and it wouldn’t have made sense for a start-up to prioritise native experience over a much wider reach via the web.

> prettylink https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a
> image /images/airbnb.jpg
> title Sunsetting React Native
> description Due to a variety of technical and organizational issues, we will be sunsetting React Native and putting all of our efforts into making native amazing.

## Native Best Practices

Move heavy business logic to the server

Re-use: code across and within apps

## Build Once?

Client apps should be lightweight

Bridging code or platform specific will need writing twice anyway
