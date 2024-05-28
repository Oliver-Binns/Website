---
date: 2024-06-01 22:00
title: A sceptic’s guide to Apple Vision Pro
image: /Images/wearing-vision-pro.png
tags: Apple Vision Pro, Swift
---

Two months ago I made a decision I’ve been putting off for several years.
I had really wanted to make iPad my only personal device; the size is more in-keeping with my love for smaller devices and I'd been inspired to be more creative by [my friend Anna’s award-winning talk on using Swift Playgrounds](https://www.youtube.com/watch?v=zfMmHiYi53Q).
iPad (especially iPad Pro) should be more than capable of performing any task (and more) that I would want to achieve.
I mean, it even contains the same M-series chips as the MacBook line-up.

In the end, I finally upgraded from my 2013 MacBook Air 11-inch to the new 2024 M3 13-inch model.

![photos of my MacBook Airs, 11" 2013, 13" 2024](../../Images/macbook-airs.png)
_My MacBook Airs (11" 2013, 13" 2024)_

I have tried a few times to use Swift Playgrounds over Xcode when starting a new side-project.
Unfortunately it has always fallen just short of what I need it to be.
When building [my conferences app](https://github.com/Oliver-Binns/Conferences), I found it didn’t support support CloudKit.
When building [a musical party game app](https://github.com/Oliver-Binns/Crescendo), I found that it didn’t support MusicKit.
When exploring SwiftData during WWDC, I found that it wouldn’t support the new APIs until they were released later in the year.
This is all before the workarounds I’d need to make to ensure I could use Git, XCTest and other tools.

Meanwhile, while iPad is great for consuming content, I don't find it much more convenience than my MacBook Air.
The only strength that iPad has here is wide-support for downloading film and TV from Netflix, Prime and BBC iPlayer for travel.

|Netflix download Mac?|iPlayer download Mac?|
|-|-|

I’ve also tried to make more use of iPad in my work-life.
Basic functions like email work well, but I find it frustrating for more in-depth work such as creating slides.
It’s trickier to align objects and to create more complex transitions.
I find myself returning to my Mac to refine documents, even if I manage to create a first draft on iPad.

Perhaps it’s not too surprising then, that I approached Apple Vision Pro with a very sceptical mind; I borrowed one from a colleague for a week trial and summarised some of my thoughts in this post.

> prettylink https://www.youtube.com/watch?v=zfMmHiYi53Q
> image /Images/anna.jpg
> title Spark Your Creativity: The Power of iPad Playgrounds | Anna Beltrami
> description Perfectionism is the enemy of creativity. Or at least, it has been for me. Spending years working in big teams with millions of users, I had forgotten how to play and experiment with iOS development. When iPad playgrounds were released, I took the opportunity to play around. Thanks to the software's simplicity, I could re-ignite my creativity and - for the first time in years - not abandon my side projects.

# Hardware

Apple have always been great at designing hardware, so it didn’t surprise me that the Vision Pro is an incredibly impressive and visually stunning device.

I only tested with the [...name] strap but it seemed comfortable for an hour or so of continuous use, which is all you will get from the battery.
The battery life easily gave me two hours which was plenty for my workflow at home while developing apps, especially since I was often sat and able to remain close to power – you can use and charge simulaneously.
The only time I ran low was when demoing to other colleagues in the office – a continuously growing queue once the word got out – but if this is a problem for you, it's detachable so you can always buy extra ones to swap out.

The screens are pixel-perfect and virtual objects are always incredibly clear.
I previously tried Vision Pro at Apple Battersea with the magnetic prescription lens inserts and now with my own contact lenses.
Both of seem to give equivalent high-quality experience.
The field-of-view is not as wide as it could be, though, as a glasses wearer, I am fairly used to that anyway.

The passthrough of video from the real world into augmented reality works really well for keeping you connected to the real world when working in the virtual world.
I have experienced only minor bouts of motion sickness which is a significant improvement when compared to my experience with other virtual reality headsets.
Unfortunately, the quality of the video is not quite similar enough to the human eye yet and the illusion breaks somewhat when trying to perform tasks in the real world – I trialed watching Disney+ while doing the washing up.

|![Media playing in Apple Vision Pro in a real world environment](../../Images/disney.png)_Media playing in Apple Vision Pro in a real world environment_|![](../../Images/wearing-vision-pro.png)|
|-|-|

# visionOS

The way that visionOS works with the hardware is where this platform really shines.
I’ve introduced Apple Vision Pro to as many friends and family members as I could (first time AR users!) and I was amazed by how quickly they were all able to get set-up and start interacting with the virtual world.
The control using hand gestures and eye tracking is incredibly intuitive and very accurate – as long as you don’t push the windows to far into the distance which makes the tap targets smaller.

As an alternative to the eye and hand-tracking you can bring windows close to you and them with multi-touch just like a virtual iPad.
The virtual keyboard works well overall but it is quite slow for any major typing.
You can attach a Bluetooth keyboard when you need to be more productive but then you obviously can’t move around as easily.

windows stay where they are: I have found myself leaving things behind and being surprised when I return a few hours later
debug mode photo showing knowledge of walls, etc

personas?

Apple are firmly positioning this as a personal device.
Like iPhone, iPad and Mac, it’s tied to a single Apple ID and has no TV-style profile switching.
While guest mode is supported, it requires resetting for each new user - you can’t just pass it to a new person and expect the setup to re-run.
It would be nice to see a more seamless implementation of detecting a change of user (using eye tracking / Optic ID?) for use-cases like demos, exhibitions, and trade-shows.

# Apps and use-cases

So… back to the scepticism I am carrying over from iPad Pro. 
Does Apple Vision Pro enable some compelling use-cases as a productivity device?

There are some high-quality apps, such as the [dinosaurs app name], which [stun-positive synonym- wow?] first-time users but they definitely feel more like one off demos.

There are some really cool new[synonym] use-cases that I would definitely use regularly.

Being able to rehearse a presentation in an immersive environment is something I will love when I next get accepted to talk at a conference - though I was disappointed to find that my Logi remote is not yet supported!

[screenshots, screenshots]

- immersive cinema (Disney+ 3D) - content permitting
- timers (not yet!)
- https://github.com/Oliver-Binns/Cards/pull/11

constrained resources (enterprise)


Mac screen-sharing - still requires a Mac.
Requires same iCloud account, which is a problem if you have separate accounts for work and personal.

# Summary

I’ve really enjoyed my time with Apple Vision Pro, and I’ll be keen to spend more time with it when it launches here in the UK.
New immersive use-cases mean it stands out from the Mac in a way that the iPad has struggled to do.
For the timebeing, just like the iPad, it’s unfortunately very much an additional device rather than an alternative.

With a likely price-tag of £3499, I will find it hard to justify the cost each time I need to upgrade my devices, however I’ll be interested to see how it evolves into the future.
WWDC is coming up in just a few weeks so we don’t have long to wait for new features in visionOS 2.0.
Apple Vision Pro runs on the same M2 chip as the Mac, so a world where you could just open up a macOS window or app doesn’t feel unattainable.
It’s also exciting to see Apple bringing their learnings from the Vision Pro across to other devices with the new iPad accessibility features they announced last week.

Meanwhile, I am also loving my new MacBook Air, but if Apple update Swift Playgrounds to add support for Swift Packages, unit tests and more, I may be kicking myself for not holding out just a little longer for the iPad Pro.
