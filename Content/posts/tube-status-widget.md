---
date: 2020-06-27 13:00
description: Create a Tube Status home-screen Widget for iOS 14
image: /images/roundel.png
tags: iOS, Swift
---
# Create a Tube Status home-screen Widget for iOS 14

One of iOS 14’s most exciting changes for both users and developers will undoubtedly be it’s addition of widgets for quick access to information directly from the home-screen without having to open the app. This type of functionality has previously been limited to just two first-party applications (Calendar and Clock).

// image here:
caption: London Underground status home-screen widgets on iOS 14

In this article, I will detail how to quickly and easily create a home-screen widget for your app, using the London Underground status board as a real-world example. Transport for London provides a free-to-use Open API (https://api.tfl.gov.uk) we can easily utilise that will allow us to get up-to-date status for all its services.

Sample code for the project is available on GitHub:

## Getting Started
### Requirements

Developing for iOS 14 requires Xcode 12. Xcode 12 will run on any Mac which is running either macOS 10.15 (Catalina) or macOS 11.0 (Big Sur). You can download it from the beta software tab on the Apple Developer Downloads page: https://developer.apple.com/download/

You can run widgets in the simulator, but to take full advantage of this tutorial, including supporting multiple widgets and intents it’s best to have a device running iOS 14 or later.

### Project Setup

_Widgets cannot be provided standalone, so we will need to start with a boilerplate app. Here we will setup a new Xcode project and produce a basic app. If you are a seasoned app developer, you may want to skip to the “Your First Widget” section._

In order to get started, let’s select “Create a new Xcode project” from the Xcode launch screen. Select app, then next.

// image here:
caption: Xcode 12 Launch window

WidgetKit requires “SwiftUI” as the interface so we will use this for our app too.
* Enter a name for your project
* Enter your own name, or company name under “Organization Identifier”.
* Select “SwiftUI” to use for the “Interface”
* Use “SwiftUI App” as the Lifecycle
* Use “Swift” as the language.

This article won’t go into detail about how to test your app, but feel free to leave the “Include Tests” box checked.

Then, finally, choose a location to store your app on your Mac.
Xcode will generate an app template containing `YourProjectApp.swift`.

### Architecture

In order to share code between the main-app and widget, we can create a shared framework in Xcode. This isn’t completely necessary for a simple app such as this, but it’s good practice as you may want to share logic further if you are implementing other features such as Siri Shortcuts or iMessage apps.

// image here:
caption: Architecture of London Underground app

Create a new framework in Xcode, go to File → New → Target… and select Framework. Some common product names for shared frameworks are “Core” or “Shared”. From now on, it’s easiest to create all new source files within this new shared framework target.

### Model

We need to create a model to represent our data. Using Swift’s Codable protocol we can automatically decode the JSON response from the TfL API.

```
public struct LineStatusUpdate: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case line = "name"
        case statuses = "lineStatuses"
    }
    public let id: String
    let line: Line
    let statuses: [StatusUpdate]
}
```

In order to keep our variable names “Swifty”, we can use coding keys to map from the response that the API returns:

```
{
    id: "bakerloo",
    name: "Bakerloo",
    lineStatuses: [ ... ]
}
```

The full model used to build the app can be found in the sample code, linked at the bottom of this article.

### Networking

We can implement a NetworkClient to handle our API calls. We will use URLSession from the [Foundation](https://developer.apple.com/documentation/foundation) library to do this.

```
import Foundation

public final class NetworkClient {
    private let session: URLSession = .shared

    enum NetworkError: Error {
        case noData
    }

    func executeRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
```
