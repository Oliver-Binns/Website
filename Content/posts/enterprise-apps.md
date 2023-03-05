---
date: 2021-03-26 20:30
title: Creating Great Enterprise Apps for iOS
image: /images/custom-apps.png
color: black
tags: iOS, Swift
---

## On Enterprise Apps

### What’s wrong?

_“There’s an App for that”_ is perhaps one of the most well-known advertising slogans of the last ten years. Indeed, since the birth of the iPhone, owners of mobile devices have come to enjoy high-quality, often freely available, applications for achieving virtually any task they can imagine.

For publicly available apps, user experience is often make or break; the App Store makes it relatively easy to find an alternative for any common app. In contrast however, Enterprise apps are generally mandated by a company’s IT department or some other internal function. Since these enterprise apps aren’t therefore subject to normal market-forces, I’ve found that they can often be of significantly lower quality, both in terms of user experience and feature sets.

Here’s a great clip from Steve Jobs talking about exactly this issue:

> youtube https://www.youtube.com/watch?v=MLvvzktuVY8

_Steve Jobs at D8 Conference, 2010_

There is seemingly little incentive for companies to improve apps which are compulsory for their employees. Or is there? More companies are starting recognise the link between internal employee user experience and employee retention. Retaining the best employees can be key to a company’s success, particularly within the technology industry.

This is likely to become an even more important battleground in the post-COVID world, as companies from around the world compete to hire the very best people. When people are working remotely- the majority of their interaction with the company they work for and its processes are via the various apps and other software it provides.

> prettylink https://monzo.com/blog/2019/02/11/internal-product-design/
> image /images/monzo.png
> title How we design our internal product
> description It’s a mistake to think that if people are paid to use a product, it doesn’t need to be easy or pleasurable to use.

## How can we fix it?

### Consider the alternatives

There are a huge number of off-the-shelf enterprise apps available. Don’t try and build your own internal app for emailing or messaging: just provide your employees with a great existing app such as Outlook or Slack. You’ll find this far cheaper (and much less stressful!) than embarking on a whole development journey.

For existing internal content, such as news items or other text-based information, which are delivered through the web when using desktop: consider optimising these sites for mobile rather than developing a mobile specific app. Let the users view this in Safari, so they have the ability to enter [Reader Mode](https://www.youtube.com/watch?v=E_j_yknaBKc), and don’t force them to access the content through a “fake”, web-view based mobile app. There’s no shame in delivering great content through the web, there is in providing users with a poor experience through a badly made web-based app.

### Don’t overcomplicate things

Still here? You must be sure a mobile app is the right thing for your use-case.

Ok: let’s start with a simple app then. This one is potentially more for app designers than developers but, as with most iOS development, I’d suggest using native components and standard UI flows wherever possible. The majority of apps in this environment can be created using tab-bars, navigation controllers, table views and the odd collection view: think Apple Music, Notes or even third-party apps like the [new GitHub app](https://apps.apple.com/app/github/id1477376905?ls=1).

This will allow you to build your app much quicker without worrying how to make your custom components. If you try and build the whole app with custom components, you can quite quickly end up with a problem of quantity over quality and end up with a poorer overall experience.

## Enterprise Apps on iOS

### Benefits

When creating a bespoke enterprise apps, that is to say one which is made for a specific organisation, you are often able to gather much better information about your users and how they will interact with your app.

Firstly, when companies provide devices to their users, developers can often make assumptions and tailor apps to these specific devices. For example, in some projects I’ve worked on we’ve only had to consider one specific iPhone or iPad screen-size, which can massively simplify both development and testing.*

Secondly, managing devices means we can add constraints, such as ensuring all our users are running the latest version of iOS. This is very exciting for developers as it means we can always use the latest APIs and features in iOS, that usually we have to wait for! As a reminder: in iOS 14 this means App Clips, Widgets and more!

## Deployment

In late 2019, Apple added support for Custom Apps deployment to iOS. This Custom Apps approach is effectively an overhaul of the not-quite-yet deprecated Developer Enterprise Program (DEP). Since then Apple has dramatically restricted entry to the DEP, likely as a response to one particular, high-profile, breach of contract.
