---
date: 2021-03-26 20:30
title: Creating Great Enterprise Apps for iOS
image: /images/custom-apps.png
color: #000000
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

> _Disclaimer: because of where my knowledge and experience lies, I’m going to assume we’re focussing on a native iOS app from this point on._
> _Some, but not all, of the point below will apply to native Android apps, cross-platform apps and hybrid apps._
> _There are also plenty of [other articles](https://medium.com/all-technology-feeds/cross-platform-vs-native-mobile-app-development-choosing-the-right-dev-tools-for-your-app-project-47d0abafee81) that will discuss the pros and cons of such things._

Ok: let’s start with a simple app then. This one is potentially more for app designers than developers but, as with most iOS development, I’d suggest using native components and standard UI flows wherever possible. The majority of apps in this environment can be created using tab-bars, navigation controllers, table views and the odd collection view: think Apple Music, Notes or even third-party apps like the [new GitHub app](https://apps.apple.com/app/github/id1477376905?ls=1).

This will allow you to build your app much quicker without worrying how to make your custom components. If you try and build the whole app with custom components, you can quite quickly end up with a problem of quantity over quality and end up with a poorer overall experience.

## Enterprise Apps on iOS

### Benefits

When creating a bespoke enterprise apps, that is to say one which is made for a specific organisation, you are often able to gather much better information about your users and how they will interact with your app.

Firstly, when companies provide devices to their users, developers can often make assumptions and tailor apps to these specific devices. For example, in some projects I’ve worked on we’ve only had to consider one specific iPhone or iPad screen-size, which can massively simplify both development and testing.*

> * Note I’d still recommend following best practice and using autolayout and size classes to support other devices.
> This way you’ll find it easier to add new devices in the future as well as potentially making your app more accessible by supporting dynamic type.

Secondly, managing devices means we can add constraints, such as ensuring all our users are running the latest version of iOS. This is very exciting for developers as it means we can always use the latest APIs and features in iOS, that usually we have to wait for! As a reminder: in iOS 14 this means App Clips, Widgets and more!

## Deployment

In late 2019, Apple added support for Custom Apps deployment to iOS. This Custom Apps approach is effectively an overhaul of the not-quite-yet deprecated [Developer Enterprise Program (DEP)](https://developer.apple.com/programs/enterprise). Since then Apple has dramatically restricted entry to the DEP, likely as a response to [one particular, high-profile, breach of contract](https://techcrunch.com/2019/01/29/facebook-project-atlas/).

> prettylink https://techcrunch.com/2019/01/29/facebook-project-atlas/
> image /images/facebook-research-vpn-project-atlas.jpg
> title Facebook pays teens to install VPN that spies on them – TechCrunch
> description Desperate for data on its competitors, Facebook has been secretly paying people to install a “Facebook Research” VPN that lets the company suck in all of a user’s phone and web activity.

For those still using the DEP, Custom Apps offers a few key advantages, over the former approach:

### Apps are uploaded to App Store Connect, as for public App Store apps
Downloads can therefore benefit from all the great App Store features: both internal and external users can access pre-release versions of the app using TestFlight, and downloads can be much faster thanks to Apple provided worldwide CDN hosting as well as [app thinning](https://developer.apple.com/documentation/xcode/reducing_your_app_s_size).

On the flip-side, since they’re now distributed through Apple, they must go through App Review in the same way as publicly App Store apps. If you’re used to developing for the App Store anyway, you’ll be used to this. Those moving from DEP to Custom Apps may find App Review adds an extra few days to their deployment process.

### Apps are re-signed by Apple

As apps are deployed to devices, they are re-signed with Apple’s master certificate. Apps signed with this certificate will not expire every year as they do with Enterprise-signed installations. Furthermore, users no longer have to install additional certificates or provisioning profiles on their device, a key gain for device security as we’re not teaching users bad habits!

### Apps can be distributed to clients

Whereas the Enterprise Program allows businesses to distribute apps to their _own employees only_, Custom Apps allows apps to be distributed to users at other organisations. This is great news for third-party Enterprise app developers, as apps no longer need to be re-signed by their clients before distribution.

N.B. Custom Apps requires Apple Business Manager, or its education sibling: Apple School Manager. As of Dec 2020, these are still only available in [69 countries](https://support.apple.com/en-gb/HT207305), so if you are deploying outside of these regions you will need to apply to be part of the DEP.

> prettylink https://developer.apple.com/videos/play/wwdc2019/304/
> image /images/adhoc-to-enterprise.jpg
> title WWDC2019 – From Ad-hoc to Enterprise
> description Whether you want to share your app with a few colleagues, deliver it to employees within an organization, or release it to the world,…

## Mobile Device Management

Most large organisations want to have some level of control over the data that their employees store on their computers, and mobile is no exception to this. 
Mobile Device Management solutions are the solution for this.

There are many off-the-shelf products for Mobile Device Management, but from a developer’s point of view, they all perform the same main functions:

* automatically configuring the device for access to employer provided tools, such as email or VPN access
* restricting certain features of the device depending on purpose:
  * i.e. iOS devices can be used in Kiosk mode for a specific application
  * full web-access can be blocked, or only certain WiFi networks may be allowed

### Managed App Configuration

All of the main Mobile Device Management solutions support Apple’s [Managed App Configuration](https://www.appconfig.org/ios/#appconfiguration).

The online documentation for Managed App Configuration is pretty poor, but the concept is simple.
The organisation can provide an XML-based .plist file containing various values that can be read by the app.

_Managed App Configuration is not exclusive to Enterprise-only apps._
You can add support for configuration to your App Store apps too, which will allow organisations to customise / pre-configure the app for their employees!
For example: [Microsoft Outlook for iOS can be pre-populated](https://docs.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/outlook-for-ios-and-android/outlook-for-ios-and-android-configuration-with-microsoft-intune) with a user’s email credentials so employees don’t need to set this up manually.

> prettylink https://support.apple.com/en-gb/guide/mdm/mdmbf9e668/1/web/1.0
> image /images/mdm-icon.png
> title MDM overview for Apple devices
> description Mobile device management lets you manage several features of Apple devices.

## Conclusion

As remote working becomes more the norm than the exception, the amount we interact with our enterprise apps is ever increasing. 
The steps I’ve laid out should be a great starting point on your journey to provide your employees or users the best possible user experience when interacting with your enterprise apps.
