//
//  PKSPage.swift
//
//
//  Created by Ömer Hamid Kamışlı on 7/1/24.
//

import SwiftUI

/// A protocol that represents a page in your app's user interface.
///
/// Conform to the `PKSPage` protocol to create custom pages that provide a view
/// and a description. The protocol ensures that each page is identifiable and hashable.
///
/// Example:
///
///     enum Pages: PKSPage {
///         case pageOne
///         case pageTwo
///         
///         var description: String = {
///             switch self {
///             case pageOne:
///                 return "Page One"
///             case pageTwo:
///                 return "Page Two"
///             }
///         }
///
///         func view() -> some View {
///             switch self {
///             case pageOne:
///                 PageOne()
///             case pageTwo:
///                 PageTwo()
///             }
///         }
///     }
///
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

public extension PKSPage {
    /// A unique identifier for the page, derived from the hash value.
    var id: Int {
        return self.hashValue
    }
}