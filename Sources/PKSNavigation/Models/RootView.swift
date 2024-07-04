//
//  RootView.swift
//  
//
//  Created by Ömer Hamid Kamışlı on 7/1/24.
//

import SwiftUI

/// A view that represents a root view in your app's user interface.
///
/// `RootView` encapsulates a wrapped view conforming to the `PKSPage` protocol,
/// providing an identifiable and hashable structure to manage the view hierarchy
/// effectively. This view helps ensure consistency in displaying content and
/// handling view-related issues.
///
/// Example:
///
///     struct ContentView: View {
///         var body: some View {
///             RootView(wrapped: MyPKSPage())
///         }
///     }
///
public struct RootView: Identifiable, Equatable, Hashable {
    
    // MARK: - Identifiable Conformance
    
    /// A unique identifier for the root view, derived from the wrapped view's ID.
    public var id: Int { wrapped.id }
    
    // MARK: - Properties
    
    /// The wrapped view conforming to the `PKSPage` protocol.
    var wrapped: any PKSPage
    
    // MARK: - Equatable Conformance
    
    /// Compares two `RootView` instances for equality based on their wrapped view's ID.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `RootView` instance.
    ///   - rhs: The right-hand side `RootView` instance.
    /// - Returns: A Boolean value indicating whether the two instances are equal.
    public static func == (lhs: RootView, rhs: RootView) -> Bool {
        rhs.wrapped.id == lhs.wrapped.id
    }
    
    // MARK: - Hashable Conformance
    
    /// Hashes the essential components of the `RootView` by combining the wrapped view.
    ///
    /// - Parameter hasher: The hasher to use when combining the components.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
    
    // MARK: - View
    
    /// The body of the `RootView`, providing the content to display.
    ///
    /// This computed property returns the wrapped view if it can be cast to `AnyView`.
    /// Otherwise, it displays a fallback message indicating an issue.
    @ViewBuilder
    public var view: some View {
        if let root = wrapped.getView() as? (any View) {
            AnyView(root)
        } else {
            VStack {
                Text("ISSUE DETECTED. SEE THE LOGS")
                    .font(.title)
                Text("POIKUS LLC")
                Text("NAVIGATION MANAGER")
            }
        }
    }
}
