# StayTuned - iOS SDK
This documentation explains you how to integrate the StayTuned SDK within all iOS platforms (iPhone / iPad). This SDK contains a Podcast player that can be launched by calling a StayTuned URL inside a WebView.

## Requirements
- iOS 9.0 or any higher version.
- Xcode 9 or any higher version.
- Swift 4.2 or any higher version.

## Installation

### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate the StayTuned SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'StayTuned', :git => 'https://github.com/StayTunedAds/staytuned-ios-sample.git'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate the StayTuned SDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
// Not available yet
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

```swift
// Not available yet
```

## Integration
After you’re done installing the SDK, configure your app to use it by following theses steps :

### 1. Configuration

You have to set a STConfigurations object to make the SDK working, here is the definition:

```swift
struct STConfigurations {
  
  // API Key given by StayTuned
  var apiKey: String
  
  // This property will be used to set the position of the chip inside the Root View Controller.
  // Optionnal: default will be at the right bottom
  var chipPosition: CGPoint? 
	
  // This property will be used when the SDK failed to load an image (low connection).
  // Optionnal: default will be a StayTuned image
  var defaultImage: UIImage?
  
}
```

You have to initialize the SDK at first. This initialization must be in your AppDelegate (do not forget to **import** the SDK):

```swift
import StayTuned

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  let configurations = STConfigurations(
    apiKey: "API_KEY",
    chipPosition: .init(x: 10, y: 10),
    defaultImage: nil
  )
  StayTuned.shared.setConfig(configurations)
}
```

### 2. Root View Controller
You have to give to the SDK a root view controller, the player will be visible upon this one if the user activate it. 

You should set this value in the viewDidLoad of your root view controller.
```swift
StayTuned.shared.setRootController(controller: self)
```

### 3. Implement the STWebView 
The STWebView object is a subclass of a [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview). Every StayTuned URL must be called by using this object to make our SDK able to show the Player.

*Reminder: As it's a WKWebView subclass, you won't be able to add a STWebView by using Interface Builder if your app support iOS 11.*
```swift
let url = URLRequest(url: "www.staytuned.io")!
let stWebView = STWKWebView(frame: view.frame)
view.addSubview(stWebView)
stWebView.load(url: url)
```

