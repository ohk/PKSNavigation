//
//  PKSDismissKey.swift
//  PKSNavigation
//
//  Created by Ömer Hamid Kamışlı on 10/2/24.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//


import SwiftUI

/// A key for accessing the `pksDismiss` closure in the environment.
///
/// The `PKSDismissKey` conforms to `EnvironmentKey` and provides a default implementation
/// for the `pksDismiss` closure, which does nothing when called.
@available(iOS 16.0, *)
public struct PKSDismissKey: EnvironmentKey {
    /// The default value for the `pksDismiss` closure.
    ///
    /// By default, the closure does nothing. It is overridden when the `PKSDismissModifier` is applied.
    public static let defaultValue: () -> Void = {}
}
