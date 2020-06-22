<H4 align="center">
  ADNavigationBarExtension is a UI library written in Swift. It allows you to show and hide an extension to your UINavigationBar
</H4>

<p align="center">
  <a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a>
  <a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift%205.0-orange.svg"/></a>
  <a href="https://cocoapods.org/pods/ADNavigationBarExtension"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/ADNavigationBarExtension.svg?style=flat"/></a>
  <a href="https://github.com/applidium/ADNavigationBarExtension/blob/master/LICENSE"><img alt="License" src="https://img.shields.io/cocoapods/l/ADNavigationBarExtension.svg?style=flat"/></a>
</p>

---

## Features

Use  `ExtensibleNavigationBarNavigationController` to set an extension under your UINavigationBar:
- The navigation controller manages the displaying of your navigation bar's extension
- It is compatible with UIAppearance

See the provided examples for help or feel free to ask directly.

---

<p align="center">
<img src="https://github.com/applidium/ADNavigationBarExtension/blob/master/Assets/example.gif" width="222">
</p>

---

- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
- [Usage](#usage)
  - [Setup](#setup)
  - [Warning](#Warning)

## Requirements

ADNavigationBarExtension is written in swift 5.0. Compatible with iOS 10.0+

## Installation

ADNavigationBarExtension is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

### Cocoapods

```ruby
pod 'ADNavigationBarExtension'
```

## Usage

### Setup

The main component of the library is the `ExtensibleNavigationBarNavigationController`.
It is basicaly a simple UINavigationController wich manages a supplementary view under the UINavigationBar.

A startup sequence might look like this:

```swift
let navigationController = ExtensibleNavigationBarNavigationController()
let navigationBarExtension = MyCustomView()
let navigationBarExtensionHeight = 64
navigationController.setNavigationBarExtensionView(navigationBarExtension, forHeight: navigationBarExtensionHeight)
navigationController.pushViewController(MyViewController(), animated: false)
window.rootViewController = navigationController
```

Then the `ExtensibleNavigationBarNavigationController` needs to know when the navigation bar's extension needs
to be displayed or to be hidden.
You have to use the protocol `ExtensibleNavigationBarInformationProvider`:

```swift
extension MyViewController: ExtensibleNavigationBarInformationProvider {
    var shouldExtendNavigationBar: Bool { return true }
}
```

### Warning

Be aware of  `ExtensibleNavigationBarNavigationController` is using the UINavigationControllerDelegate protocol.
So if you also need to use de navigationController's delegate proprerty, you can use this:

```swift
let navigationController = ExtensibleNavigationBarNavigationController()
navigationController.navigationControllerDelegate = self
```

There is an issue with iOS 12 where the `isTranslucent` property cannot be retrieved from the
`UINavigationBar.appearance()` method.
So if you need to set your UINavigationBar translucent, you can use this:

```swift
ExtensibleNavigationBarNavigationController.ad_isTranslucent = true
```

## Credits

ADNavigationBarExtension is owned and maintained by [Fabernovel](https://fabernovel.com/). You can follow us on Twitter at [@FabernovelApp](https://twitter.com/fabernovelapp).


## License

ADNavigationBarExtension is released under the MIT license. [See LICENSE](LICENSE) for details.
