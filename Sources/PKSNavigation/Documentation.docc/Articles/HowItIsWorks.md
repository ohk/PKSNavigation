# How it works

@Metadata {
@PageImage(purpose: "card", source: "card-how-it-works", alt: "Image of a dark-themed banner featuring the logo of a stylized butterfly with gradient colors transitioning from purple on the left to blue on the right. Next to the logo, the text 'PKSNavigation' is prominently displayed in white, followed by the smaller subheading 'How it works' below it. The overall design has a modern, sleek aesthetic with a smooth gradient background that transitions from dark blue to purple at the bottom.")
}

Explore how **PKSNavigation** streamlines navigation in SwiftUI by offering three distinct navigation types. Delve into the underlying logic that enables seamless switching between different presentation methods, and discover how these enhancements optimize and elevate the overall navigation experience.

PKSNavigation simplifies navigation in SwiftUI by providing three main navigation types:

1. **Stack-Based Navigation**
2. **Sheet Presentation**
3. **Full-Screen Cover Presentation**

All these navigation types are managed through a single, unified API, making your navigation logic consistent and easy to handle. PKSNavigation enhances the fundamental navigation mechanisms by allowing seamless integration and interaction between different navigation styles. This is achieved through intelligent management of navigation states and presentation methods, ensuring that transitions between navigation types are smooth and intuitive.

## Enhanced Navigation Mechanisms

PKSNavigation builds upon the basic navigation types by offering enhanced capabilities:

- **Unified API**: Manage stack, sheet, and cover navigations using a single set of methods.
- **Harmonious Integration**: Different navigation types work seamlessly together, allowing complex navigation flows without intricate management.
- **Flexible Presentation Management**: Easily switch between navigation types or nest them within each other to suit your app's needs.

## Navigation Types

### 1. Stack-Based Navigation

- **How It Works**: Views are added to or removed from a navigation stack.
- **Use Case**: Ideal for hierarchical navigation where you push and pop views.
- **Example**: Navigating from a list to a detail view.

**Enhancements with PKSNavigation**:

- **Default Mechanism**: Stack-based navigation is the default navigation method.
- **Unified Control**: Easily add or remove views from the root stack using the unified API.
- **Nested Navigation**: Perform stack-based navigation within sheets or full-screen covers effortlessly.

### 2. Sheet Presentation

- **How It Works**: Views are presented as sheets that slide up from the bottom, covering part of the screen.
- **Use Case**: Suitable for modal interactions like forms or settings.
- **Example**: Presenting a settings screen over the current view.

**Enhancements with PKSNavigation**:

- **Integrated Stack Navigation**: Sheets come with their own navigation stack by default, allowing you to push and pop views within the sheet.
- **Flexible Presentation**: You can add new sheets or switch to full-screen covers from within a sheet, maintaining separate navigation contexts.
- **Multiple Sheets Support**: Register multiple sheet stacks to present multiple sheets simultaneously using `registerSheetStack()`.

### 3. Full-Screen Cover Presentation

- **How It Works**: Views are presented as full-screen covers, replacing the current view entirely.
- **Use Case**: Best for scenarios where you need to take over the entire screen.
- **Example**: Displaying a login screen that covers the whole app interface.

**Enhancements with PKSNavigation**:

- **Integrated Stack Navigation**: Full-screen covers use stack-based navigation by default, enabling navigation within the cover.
- **Nested Navigation**: From within a cover, you can present additional sheets or covers, each maintaining their own navigation stacks.
- **Multiple Covers Support**: Register multiple cover stacks to manage multiple full-screen covers concurrently using `registerCoverStack()`.

## Logic Behind Switching Between Presentation Methods

PKSNavigationManager intelligently manages the switching between different presentation methods to ensure smooth and consistent navigation flows within your app. Here's how the logic works:

1. **Single Unified API**: All navigation actions are performed through the `navigate(to:presentation:isRoot:)` method, regardless of the current presentation method. This simplifies the navigation logic by providing a consistent interface.

2. **Active Presentation Tracking**: The navigation manager keeps track of the currently active presentation method (`.stack`, `.sheet`, `.cover`). This determines which navigation stack (`rootPath`, `sheetPath`, or `coverPath`) should handle the navigation action.

3. **Context-Aware Navigation**:

   - **Stack Navigation**: If the active presentation is `.stack`, the navigation action affects the root stack.
   - **Sheet Navigation**: If the active presentation is `.sheet`, the navigation action affects the sheet's navigation stack (`sheetPath`). If a sheet stack is not registered, the action is delegated to the parent manager.
   - **Cover Navigation**: If the active presentation is `.cover`, the navigation action affects the cover's navigation stack (`coverPath`). If a cover stack is not registered, the action is delegated to the parent manager.

4. **Nested Presentation Handling**:

   - **Within Sheets and Covers**: When navigating within a sheet or cover, the manager ensures that the navigation actions affect the appropriate nested navigation stack. This allows for complex navigation flows without conflict between different presentation contexts.

5. **Registration of Additional Stacks**: By registering sheet and cover stacks using `registerSheetStack()` and `registerCoverStack()`, you inform the navigation manager to handle multiple sheets or covers, each with their own navigation stacks. This enables presenting multiple sheets or covers simultaneously without navigation conflicts.

6. **Delegation to Parent Managers**: For hierarchical or nested navigation flows, navigation actions can be delegated to a parent navigation manager. This allows for organized navigation management in large-scale applications with complex navigation requirements.

7. **Automatic Presentation Method Switching**: The navigation manager automatically switches the active presentation method based on the current navigation state and the type of navigation action being performed. This ensures that navigation transitions are handled smoothly without requiring manual intervention from the developer.

**Example Scenario**:

- **Initial Navigation**: The app starts with stack-based navigation (`.stack`), allowing users to navigate from Home to Detail views.
- **Presenting a Sheet**: From the Detail view, a settings sheet is presented (`.sheet`). The sheet itself has its own stack-based navigation, allowing users to navigate within the sheet.
- **Presenting a Cover from Sheet**: While in the settings sheet, a login full-screen cover is presented (`.cover`). The cover also maintains its own stack-based navigation.
- **Switching Contexts**: Navigating back from the cover returns to the sheet's stack, and navigating back from the sheet returns to the root stack.

This intelligent management ensures that each presentation context maintains its own navigation flow, and switching between them is handled seamlessly by PKSNavigation.

By enhancing the fundamental navigation mechanisms and managing the switching logic internally, PKSNavigation provides a robust and flexible solution for handling complex navigation flows in SwiftUI applications. This allows developers to focus on building their app's features without worrying about the intricacies of navigation management.
