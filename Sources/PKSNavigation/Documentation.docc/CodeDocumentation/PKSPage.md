# ``PKSPage``

`PKSPage` is a protocol designed to represent individual pages within your SwiftUI application's user interface. This documentation provides straightforward examples to help you integrate `PKSPage` into your project seamlessly.

## Conforming to PKSPage

`PKSPage` requires conforming types to implement `Hashable` and `Identifiable`. This ensures each page is uniquely identifiable and can be efficiently managed within navigation stacks.

### Protocol Definition

```swift
import SwiftUI

@available(iOS 16.0, *)
public protocol PKSPage: Hashable, Identifiable {

    /// The type of view representing the body of this page.
    associatedtype Body: View

    /// A view builder that constructs the view for this page.
    ///
    /// Implement this method to provide the content for your custom page.
    @MainActor @ViewBuilder var body: Self.Body { get }

    /// A description of the page.
    var description: String { get }
}
```

## Methodology One: Enum-Based Pages

Use an `enum` when you have a fixed set of pages. This approach promotes simplicity and type safety.

```swift
import SwiftUI
import PKSNavigation

// Define the Pages enum conforming to PKSPage
enum Pages: PKSPage {
    case home
    case settings

    // Description for debugging
    var description: String {
        switch self {
        case .home:
            return "Home Page"
        case .settings:
            return "Settings Page"
        }
    }

    // SwiftUI view for each page
    @ViewBuilder
    var body: some View {
        switch self {
        case .home:
            HomeView()
        case .settings:
            SettingsView()
        }
    }
}

// Example HomeView
struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Home Page")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }
}

// Example SettingsView
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }
}
```


## Methodology Two: Struct-Based Pages

Use `structs` when pages require associated data or more complex configurations. This method is ideal for dynamic content.

```swift
import SwiftUI
import PKSNavigation

// Define a HomeView conforming to PKSPage
struct HomeView: PKSPage {
    var description: String {
        return "HomeView"
    }

    @ViewBuilder
    var body: some View {
        VStack {
            Text("Welcome to the Home Page")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }
}

// Define a SettingsView conforming to PKSPage
struct SettingsView: PKSPage {

    var description: String {
        return "SettingsView"
    }

    @ViewBuilder
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }
}

// Example of a dynamic page with associated data
struct ProfileView: PKSPage {
    let userID: String

    var description: String {
        return "ProfileView for user \(userID)"
    }

    @ViewBuilder
    var body: some View {
        VStack {
            Text("Profile of \(userID)")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }
}
```


## Conclusion

`PKSPage` offers a flexible and type-safe way to manage pages within your SwiftUI application. Whether you prefer enum-based simplicity or struct-based flexibility, `PKSPage` adapts to your architectural needs, ensuring a maintainable and scalable navigation structure.

For more detailed information and advanced configurations, refer to the [Deep Dive into PKSPage Documentation](<doc:DeepDiveToPKSPage>).
