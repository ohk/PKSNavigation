# PKSNavigation

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Issues](https://img.shields.io/github/issues/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/issues)
[![Contributors](https://img.shields.io/github/contributors/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/graphs/contributors)
[![Version](https://img.shields.io/github/v/release/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/releases)

**PKSNavigation** is a simple yet powerful navigation framework designed for SwiftUI applications. It helps you manage complex navigation flows with ease, supporting stack-based navigation, sheet presentations, and full-screen covers. Whether you're building a small app or a large-scale project, PKSNavigation streamlines your navigation logic, making your code cleaner and more maintainable.

## 🚨 Important Notice

- Important: PKSNavigation requires **iOS 16** or later.
- Warning: This framework is optimized for **iPhone** devices. It hasn't been tested or developed for iPad. If you encounter any issues while developing for iPad, please [open an issue](https://github.com/ohk/PKSNavigation/issues) on our GitHub repository.

## 🌟 Features

- 🛠️ **Unified API**: Manage all navigation types using a single, consistent API.
- 🔀 **Nested Navigation**: Support for parent and child navigation managers for complex flows.
- 📜 **Navigation History**: Keep track of navigation events for easy back navigation.
- 📝 **Comprehensive Logging** for debugging
- 🧩 **Modular Architecture** for easy integration and customization

## Installation

### Swift Package Manager

You can install PKSNavigation using the [Swift Package Manager](https://swift.org/package-manager/):

1. In Xcode, open your project and navigate to File → Swift Packages → Add Package Dependency...
2. Paste the repository URL: https://github.com/ohk/PKSNavigation.git
3. Click Next and select the version you want to use

## Usage

Here's a simple example demonstrating how to use PKSNavigation for stack-based navigation:

```swift
import SwiftUI
import PKSNavigation

struct ContentView: View {
    @StateObject private var navigationManager = PKSNavigationManager()

    var body: some View {
        PKSNavigationContainer(navigationManager: navigationManager) {
            HomeView()
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager

    var body: some View {
        VStack {
            Text("Home View")
                .font(.largeTitle)
            Button("Go to Detail in Stack") {
                navigationManager.navigate(to: RootPages.detail)
            }

            Button("Go to Detail on Sheet") {
                navigationManager.navigate(to: RootPages.detail, presentation: .sheet)
            }

            Button("Go to Detail in Stack") {
                navigationManager.navigate(to: RootPages.detail, presentation: .cover)
            }
        }
    }
}

struct DetailView: View {
    @Environment(\.pksDismiss) var dismiss

    var body: some View {
        VStack {
            Text("Detail View")
                .font(.largeTitle)
            Button("Go Back") {
                dismiss()
            }
        }
    }
}

// Define your pages conforming to PKSPage
enum RootPages: PKSPage {
    case detail

    var description: String {
        switch self {
        case detail:
            return "Detail Page"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case detail:
            DetailView()
        }
    }
}
```

For more detailed usage and advanced features, please refer to our [documentation](https://github.com/ohk/PKSNavigation/wiki).

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## Code of Conduct

We have adopted the [Contributor Covenant](CODE_OF_CONDUCT.md) as our code of conduct.

## License

PKSNavigation is released under the MIT license. See [LICENSE](LICENSE) for details.