---
title: Behaviour-driven unit testing in UIKit
image: /images/wordpress-native.png
tags: iOS, Swift
---

As stated by the F.I.R.S.T. principles of software testing, our tests should be thorough. By extension, I would argue that these tests should attempt to cover behaviour from a user’s perspective, rather than just directly calling methods in the code.

> prettylink https://medium.com/@tasdikrahman/f-i-r-s-t-principles-of-testing-1a497acda8d6
> image https://miro.medium.com/max/852/1*JFQepSJprVacT6gkPv5aCw.jpeg
> title F.I.R.S.T principles of testing
> description F.I.R.S.T. principles of testing mean that tests should be Fast, Isolated/Independent, Repeatable, Self-validating and Thorough.

As with other forms of testing, test cases should be derived from our business' requirements, both explicit and inferred, and used to validate that these requirements have been met by our code;

![](/images/testing-loop.jpg)

_A closed-loop system where our app implements the business requirements and our tests validate that the requirements are met_

In my previous post, on automation, I wrote about the importance of adding gates to your release process to ensure quality. One of these gates should always be a set of unit tests which are run to ensure your app behaves correctly. Testing in this behaviour-driven way, will help to ensure your unit test gates are truly valuable, protecting your code from regressions, therefore allowing you to develop faster and more safely.

> prettylink /posts/gitflow-automation/
> image /images/git-flow.jpg
> title Gitflow with Automation for Mobile Apps
> description Gitflow is a great branching strategy for mobile apps. Automation is essential for achieving our agile principle of delivering working software frequently. Combining these two processes can reduce the burden of deployment, helping us focus on regularly delivering great apps for our users.

## IBOutlets and IBActions

Tap buttons using sendAction rather than calling actions directly

IBOutlets and actions should be private as otherwise we are leaking implementation details of our API outside of the class. Other developers in our team may use these in a way we did not design them causing bugs. 

### SwiftLint

SwiftLint can be used to enforce private variables using the [private\_outlet](https://realm.github.io/SwiftLint/private_outlet.html) and [private\_action](https://realm.github.io/SwiftLint/private_action.html) rules. I would recommending enabling these.

### Finding UI Elements

_If all of our UI elements are private, how do we test them?_

If you've ever written UI tests, you'll be familiar with finding elements by their accessibility identifier, but we can also do this in our unit test cases. Here's a couple of methods I use in many of my projects for this exact purpose:

```
extension XCTestCase {
    func findChild<T: UIView>(of uiView: UIView,
                              withIdentifier accessibilityIdentifier: String) throws -> T {
        let casted = uiView
            .findChild(withIdentifier: accessibilityIdentifier) as? T
        return try XCTUnwrap(casted)
    }
}

extension UIView {
    func findChild(withIdentifier accessibilityIdentifier: String) -> UIView? {
        if let child = subviews
            .first(where: { $0.accessibilityIdentifier == accessibilityIdentifier }) {
            return child
        }
        // Recurse to find a matching child in each subview!
        return subviews.lazy.compactMap {
            $0.findChild(withIdentifier: accessibilityIdentifier)
        }.first
    }
}
```

We can now find the UI element, such as a button, using its accessibility identifier, while keeping our outlets and actions private.

This has a number of benefits:

* it allows us to be more explicit about how we expect other developers to use our class by publicising only the properties that we are expecting to be used
* it allows us to test actions from a user's perspective by sending events (i.e. a gesture or tap) to the element
* it adds consistency between our unit and our UI testing

### Testing Interaction

Once we have found the button, we can send touch events to it. In iOS, the most commonly used touch event is "touch up inside" which is triggered when their user lifts their finger up and away from the button on the screen. This is a great implementation of a button press as it allows the user to cancel the touch event, if they make a mistake, by dragging away from where they originally pressed.

```
func testConfirmButtonShowsSuccessScreen() {
    let button: UIButton = findChild(of: sut, 
                                     withIdentifier: "confirm-button")
    button.sendActions(for: .touchUpInside)

    // Now: make assertions about buttons
}
```

## Gesture Recognisers

Many of our apps will take advantage of gesture recognisers in iOS. These kind of interactions, including pinch and swipe, have been a hallmark feature of the platform since it was first announced.

> youtube https://youtu.be/VQKMoT-6XSg?t=970

Luckily, when unit testing we can access these interactions via the gestureRecognizers property on UIView. This means we can also keep our gesture recognizer references, and the methods they call, private without our classes.

We can test these trivially:

```
func testGestureRecogniser() {
    guard let gesture = view.gestureRecognizers?.

}
```

## UIAlertController

We should never use private APIs in our app targets, doing so will almost certainly prevent us from passing through App Review to deploy on the App Store. However, I've found them useful to use these for certain very limited use-cases when unit testing: for example, triggering UIAlertActions.

```
extension UIAlertAction {
     typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
 

     // MARK: - Helper: Use Private APIs (naughty!) to trigger gesture recogniser
     // Do not use this in the main app bundle as it will result in rejection from the App Store!
     public func runHandler() {
         guard let handler = value(forKey: "handler") else { return }
         unsafeBitCast(handler as AnyObject, to: AlertHandler.self)(self)
     }
 }
```

## UIBarButtonItem

```
extension UIBarButtonItem {
    func sendAction(file: StaticString = #file, line: UInt = #line) {
        guard let action = action else {
            XCTFail("This navigation item does not have an action set", 
                    file: file, line: line)
            return
        }
        UIApplication.shared
            .sendAction(action, 
                        to: target, 
                        from: self, 
                        for: nil)
    }
}
```
