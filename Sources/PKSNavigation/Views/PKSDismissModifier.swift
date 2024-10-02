//
//  PKSDismissModifier.swift
//  PKSNavigation
//
//  Created by Ömer Hamid Kamışlı on 10/2/24.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//


import SwiftUI

/// A view modifier that injects a dismiss closure into the environment.
///
/// The `PKSDismissModifier` allows views to access a `pksDismiss` closure from the environment,
/// which can be called to dismiss the current view using the provided `PKSNavigationManager`.
///
/// - Note: This modifier requires a `PKSNavigationManager` to be passed during initialization.
///
/// - Author: Omer Hamid Kamisli
struct PKSDismissModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// The navigation manager responsible for handling navigation actions.
    ///
    /// Observes the `PKSNavigationManager` to perform navigation when the `pksDismiss` closure is called.
    @ObservedObject var navigationManager: PKSNavigationManager
    
    // MARK: - Body
    
    /// Modifies the content view by injecting the `pksDismiss` closure into the environment.
    ///
    /// - Parameter content: The original content view.
    /// - Returns: A view modified with the `pksDismiss` closure in its environment.
    func body(content: Content) -> some View {
        content.environment(\.pksDismiss, {
            navigationManager.navigateBack()
        })
    }
}

public extension View {
    /// Injects the `pksDismiss` closure into the environment for the view hierarchy.
    ///
    /// This method applies the `PKSDismissModifier` to the view, allowing child views to access
    /// the `pksDismiss` closure from the environment. The closure uses the provided
    /// `PKSNavigationManager` to navigate back in the navigation stack.
    ///
    /// - Parameter navigationManager: An instance of `PKSNavigationManager` responsible for handling navigation actions.
    /// - Returns: A view modified with the `pksDismiss` closure in its environment.
    func pksDismissEnvironment(navigationManager: PKSNavigationManager) -> some View {
        self.modifier(PKSDismissModifier(navigationManager: navigationManager))
    }
}
