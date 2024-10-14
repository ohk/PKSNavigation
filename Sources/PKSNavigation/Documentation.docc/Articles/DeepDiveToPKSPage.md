# Deep Dive to PKSPage

In this guide, you'll learn how to leverage the ``PKSPage`` protocol to create modular, identifiable, and hashable pages within your SwiftUI applications. Whether you're building a simple app or a complex navigation system, ``PKSPage`` provides the flexibility and structure you need to manage your app's user interface efficiently.

``PKSPage`` is a protocol designed to represent individual pages within your SwiftUI application's user interface. By conforming to ``PKSPage``, you ensure that each page is:

- **Identifiable**: Each page has a unique identifier, making it easy to manage and reference.
- **Hashable**: Pages can be compared and stored in collections efficiently.
- **View-Providing**: Each page provides its own SwiftUI `View`, encapsulating its UI components and behavior.
- **Descriptive**: Each page includes a description, enhancing readability and maintainability.

### Key Features

- **Modularity**: Define each page separately, promoting clean and organized code.
- **Flexibility**: Easily integrate with navigation systems like `PKSNavigation`.
- **Type Safety**: Leverage Swift's type system to ensure consistency across your pages.

## Conforming to the PKSPage Protocol

To utilize ``PKSPage``, you'll need to create types that conform to the protocol. This ensures that each page adheres to the required structure and functionalities.

### Understanding the PKSPage Protocol

```swift
import SwiftUI

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

extension PKSPage {
    /// A unique identifier for the page, derived from the hash value.
    public var id: Int {
        return self.hashValue
    }
}
```

### Protocol Breakdown

- **Associated Type `Body`**: Defines the type of `View` that represents the page's content.
- **`body` Property**: A view builder that constructs the page's UI.
- **`description` Property**: Provides a textual description of the page.
- **`id` Property**: Automatically derived from the hash value, ensuring each page is uniquely identifiable.

## Implementing Custom Pages

Let's create custom pages by conforming to `PKSPage`. We'll define an enumeration `Pages` that represents different pages in the app.

### Example: Defining Pages (Variation One)

```swift
import SwiftUI
import PKSNavigation

enum Pages: PKSPage {
    case home
    case settings

    var description: String {
        switch self {
        case .home:
            return "Home Page"
        case .settings:
            return "Settings Page"
        }
    }

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
```

### Example: Defining Pages (Variation Two)

```swift
import SwiftUI
import PKSNavigation

struct HomeView: PKSPage {
    var body: some View {
        VStack {
            Text("Welcome to the Home Page")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }

    var description: String {
        return "HomeView"
    }
}

struct SettingsView: PKSPage {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            // Additional UI components
        }
    }

    var description: String {
        return "SettingsView"
    }
}
```

### Explanation

- **Enumeration Cases**: Each case represents a distinct page (`home` and `settings`).
- **`description`**: Provides a readable description for each page.
- **`body`**: Returns the corresponding `View` for each page.

## Integrating PKSPage with PKSNavigation

To manage navigation between different pages, integrate ``PKSPage`` with `PKSNavigation`. This allows for a seamless and structured navigation flow within your app.

### Step 1: Initialize PKSNavigationManager

Create instances of `PKSNavigationManager` for managing navigation states.

```swift
import SwiftUI
import PKSNavigation

struct ContentView: View {
    @StateObject private var homeNavigation = PKSNavigationManager(identifier: "HomeNavigation")
    @StateObject private var settingsNavigation = PKSNavigationManager(identifier: "SettingsNavigation")

    var body: some View {
        TabView {
            PKSNavigationContainer(navigationManager: homeNavigation) {
                HomeRootView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            PKSNavigationContainer(navigationManager: settingsNavigation) {
                SettingsRootView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
```

### Step 2: Configure PKSNavigationContainer

Wrap each page's root view with `PKSNavigationContainer`, passing the respective `PKSNavigationManager` instance. This setup ensures that each tab manages its own navigation stack independently.

### Step 3: Define Navigation Flow

Within each view (e.g., `HomeView` and `SettingsView`), use `PKSNavigationManager` to navigate to other pages as needed.

#### Variation One

```swift
struct HomeView: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager

    var body: some View {
        VStack {
            Text("Welcome to the Home Page")
                .font(.largeTitle)
                .padding()

            Button(action: {
                navigationManager.navigate(to: Pages.settings)
            }) {
                Text("Go to Settings")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
```

#### Variation Two

```swift
struct HomeView: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager

    var body: some View {
        VStack {
            Text("Welcome to the Home Page")
                .font(.largeTitle)
                .padding()

            Button(action: {
                navigationManager.navigate(to: SettingsView())
            }) {
                Text("Go to Settings")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
```

## Enums with Parameters

### Description

In more complex applications, pages may require parameters to customize their content or behavior dynamically. By defining enum cases with associated values, you can pass necessary data to your pages seamlessly. This approach enhances flexibility and reusability, allowing the same page structure to display different content based on the provided parameters.

```swift
// MARK: Pages
enum Pages: PKSPage {
    case simplePage
    case pageWithParam(title: String)
    case pageWithObject(configuration: ObjectConfiguration)
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .simplePage:
            SimplePageView()
        case .pageWithParam(let title):
            PageWithParamView(title: title)
        case .pageWithObject(let configuration):
            PageWithObjectView(configuration: configuration)
        }
    }
    
    var description: String {
        switch self {
        case .simplePage:
            return "Simple Page"
        case .pageWithParam(let title):
            return "Page with Parameter - \(title)"
        case .pageWithObject(let configuration):
            return "Page with Object - \(configuration.toString())"
        }
    }
}

// MARK: ObjectConfiguration
struct ObjectConfiguration: Hashable, Equatable {
    var a: String
    var b: Bool
    var c: Int
}

extension ObjectConfiguration {
    func toString() -> String {
        return "A: \(a) - B: \(b) - C: \(c)"
    }
}

// MARK: Views
struct SimplePageView: View {
    var body: some View {
        Text("Simple Page")
            .font(.title)
            .padding()
    }
}

struct PageWithParamView: View {
    var title: String
    var body: some View {
        Text("Page with Title: \(title)")
            .font(.title)
            .padding()
    }
}

struct PageWithObjectView: View {
    var configuration: ObjectConfiguration
    var body: some View {
        VStack {
            Text("Page with Configuration")
                .font(.title)
                .padding()
            Text(configuration.toString())
                .font(.body)
                .padding()
        }
    }
}
```

### Explanation

- **Enumeration Cases with Associated Values**:
  - `simplePage`: Represents a basic page without additional parameters.
  - `pageWithParam(title: String)`: Allows passing a `title` to customize the page's content.
  - `pageWithObject(configuration: ObjectConfiguration)`: Enables passing a complex object for more detailed configurations.
  
- **`description`**: Provides a readable description for each page, including the associated parameters where applicable.
  
- **`body`**: Returns the corresponding `View` for each page, utilizing the provided parameters to customize the UI.

## Author's Recommendations

- **Use Enum-Based Navigation for Complex Flows**: If your application has intricate navigation requirements, leveraging enum-based navigation will significantly enhance code readability and maintainability. Enums clearly define all possible navigation paths, making it easier to understand and manage the flow.

- **Separate Navigation Flows Using Enums**: Each distinct flow in your application should have its own enum. This separation ensures that different sections of your app, such as Settings and Home, operate independently without interfering with one another. For example, the Settings flow shouldn't interact with the Home flow, adhering to the **Single Responsibility Principle**.

- **Maintain Type Safety Across Pages**: By defining your pages using the ``PKSPage`` protocol and enums, you leverage Swift's strong type system. This approach minimizes runtime errors and ensures that all navigation actions are predictable and consistent.

- **Encapsulate Page Logic Within Views**: Keep the logic related to each page within its respective `View` struct. This encapsulation promotes modularity and makes it easier to test and reuse components across your application.

- **Utilize Descriptive Naming Conventions**: Assign clear and descriptive names to your pages and their associated parameters. This practice enhances code readability and makes it easier for other developers (or your future self) to understand the purpose and functionality of each component.


Happy coding!
