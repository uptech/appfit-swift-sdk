# AppFit for Swift

The Swift SDK allows you to drop-in analytic tracking, direct to your AppFit project.

## Getting Started

Before you can start tracking events, you have to grab your API Key from your AppFit Dashboard

## Installing

Use Swift Package Manager to install RepresentableKit.

Use Xcode and add this repository as a dependency.
Alternatively, add this repository as a dependency to your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/uptech/appfit_sdk_swift.git", .upToNextMajor(from: "1.0.0"))
]
```

## Configuration

To configure the AppFit SDK, simply construct an `AppFitConfiguration` class and insert your API Key.

Your API Key can be obtained from your AppFit Dashboard.

```swift
let configuration = AppFitConfiguration(apiKey: "<key>")
```

## Tracking Events

You can read more here, and find examples about tracking events, on the [tracking](tracking) page.

[tracking]: "TRACKING.md" "Event Tracking"
