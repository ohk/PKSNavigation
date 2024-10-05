# PKSNavigation

PKSNavigation is a powerful and flexible navigation framework for SwiftUI applications. It provides a robust solution for managing complex navigation flows, supporting stack-based, sheet, and full-screen cover presentations.

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Issues](https://img.shields.io/github/issues/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/issues)
[![Contributors](https://img.shields.io/github/contributors/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/graphs/contributors)
[![Version](https://img.shields.io/github/v/release/ohk/PKSNavigation)](https://github.com/ohk/PKSNavigation/releases)

## Features

- 🧭 Unified navigation management for stack, sheet, and full-screen presentations
- 🔄 Easy-to-use API for programmatic navigation
- 📚 Support for nested navigation flows
- 🎨 Customizable presentation styles
- 📝 Comprehensive logging for debugging
- 🧩 Modular architecture for easy integration and customization

## Installation

### Swift Package Manager

You can install PKSNavigation using the [Swift Package Manager](https://swift.org/package-manager/):

1. In Xcode, open your project and navigate to File → Swift Packages → Add Package Dependency...
2. Paste the repository URL: https://github.com/ohk/PKSNavigation.git
3. Click Next and select the version you want to use

## Usage

Here's a quick example of how to use PKSNavigation in your SwiftUI app:

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
        Button("Go to Detail") {
            navigationManager.navigate(to: DetailPage(), presentation: .stack)
        }
    }
}

struct DetailPage: PKSPage {
    var body: some View {
        Text("Detail View")
    }

    var description: String {
        "Detail Page"
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