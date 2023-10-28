---
date: 2020-07-23 18:00
title: Constructing Data with Swift Result Builders
image: /Images/lego.jpg
tags: Swift, Server-Side, Vapor, Bitrise
---

When Apple introduced SwiftUI in 2019, they showed how Swift 5.1’s result builders could be used to quickly, and readably, build user interfaces containing a wide range of elements. In Swift 5.4 (bundled with Xcode 12.5 or later), these have been renamed “result builders” and are now a public language feature. Therefore, as developers we can readily use them ourselves when building arrays of objects in our code.

In iOS apps we often use `UIAlertController` to display error messages. I often see the following extension on `UIViewController`, allowing alerts to be easily presented throughout the app.

```
extension UIViewController {
    func presentAlert(title: String, message: String,
                      actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
```

Often this results in some logic at the call site when there are alerts that change depending on the message being displayed. For example, we may want to handle an error that comes back from one of our API calls. In this case, the error may either be resolvable or not depending on its HTTP status code. If it is a resolvable error we want to give the user the option to retry.

```
func handleAPIError(_ error: NetworkError) {
    var actions = [UIAlertAction(title: "Cancel", style: .cancel)]
    let errorIsResolvable = (500...599).contains(error.code)
    if errorIsResolvable {
        actions.append(
            UIAlertAction(title: "Retry", style: .default) { _ in
                retryRequest()
            }
        )
    }
    
    navigationController?.presentAlert(title: "An Error Occurred",
                                       message: error.localizedDescription,
                                       actions: actions)
}
```

This logic isn’t too complex, but if we were to have a number of conditions or actions to append it can become messy very quickly. To prevent this, we could create a result builder for in-place of the array of actions that we were originally passing in.

This will allow us to add actions, or not, in the same way that we do when building our SwiftUI views.

```
@resultBuilder
public struct UIAlertActionBuilder {
    public static func buildBlock() -> [UIAlertAction] {
        []
    }

    public static func buildBlock(_ elements: UIAlertAction...) -> [UIAlertAction] {
        elements.compactMap { $0 }
    }

    public static func buildBlock(_ elements: [UIAlertAction]...) -> [UIAlertAction] {
        elements.flatMap { $0 }
    }

    public static func buildIf(_ elements: [UIAlertAction]?) -> [UIAlertAction] {
        elements ?? []
    }
}
```

```
extension UIViewController {
    func presentAlert(title: String?, message: String?,
                      @UIAlertActionBuilder actions: () -> [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions().forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
```

Our original logic can now become much more readable (and declarative).

```
func handleAPIError(message: String, code: Int) {
    let errorIsResolvable = (500...599).contains(code)
    navigationController?.presentAlert(title: "An Error Occurred",
                                       message: message) {
        UIAlertAction(title: "Cancel", style: .cancel)
        if errorIsResolvable {
            UIAlertAction(title: "Retry", style: .default) { _ in
                retryRequest()
            }
        }
    }
}
```

Without much change, we can even take this one step further by creating a _generic_ `ArrayBuilder`. This will allow us to build arrays of any type that can be useful in all sorts of places in our codebase.

```
@resultBuilder
public struct ArrayBuilder<T> {
    public static func buildBlock() -> [T] {
        []
    }
    
    // ... etc.
}
```

We can also implement the methods for `buildEither` so that we can support `else` branches when building arrays.

```
public static func buildEither(first: [T]) -> [T] {
    first
}

public static func buildEither(second: [T]) -> [T] {
    second
}
```

In order to use this new `ArrayBuilder` in place of our `UIAlertActionBuilder`.
We would simply use the following snippet:

```
func presentAlert(title: String?, message: String?,
                  @ArrayBuilder<UIAlertAction> actions: () -> [UIAlertAction])
```

As you can see, result builders can be an invaluable tool to help create lists of data cleanly in Swift. There are often places in our apps where elements may or may not appear.

It’s helped me to massively reduce the amount of code needed, for example in Settings menus, for some of my apps: where certain settings are shown or hidden depending on others and the profile of the user who views the page.
