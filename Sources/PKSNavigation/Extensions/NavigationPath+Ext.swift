//
//  NavigationPath+Ext.swift
//
//
//  Created by Ömer Hamid Kamışlı on 7/1/24.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//

import SwiftUI

/// An extension that provides additional utility methods for `NavigationPath`.
///
/// This extension adds methods to safely remove the last element of the path
/// and to clear all elements in the path.
///
/// Example:
///
///     var path = NavigationPath()
///     path.append("FirstPage")
///     path.removeLastIfAvailable() // Removes "FirstPage" if it exists
///     path.clear() // Clears the entire path
///
@available(iOS 16.0, *)
extension NavigationPath {

    /// Removes the last element of the path if it exists.
    ///
    /// Use this method to safely remove the last element of the `NavigationPath`
    /// without causing an out-of-bounds error.
    mutating func removeLastIfAvailable() {
        if !self.isEmpty {
            self.removeLast()
        }
    }

    /// Clears all elements in the path.
    ///
    /// Use this method to remove all elements from the `NavigationPath`,
    /// effectively resetting the path.
    mutating func clear() {
        if !self.isEmpty {
            self.removeLast(self.count)
        }
    }
}
