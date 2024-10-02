//
//  EnvironmentValues+PksDismiss.swift
//  PKSNavigation
//
//  Created by Ömer Hamid Kamışlı on 10/2/24.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//

import SwiftUI

public extension EnvironmentValues {
    /// A closure that can be called to dismiss the current view.
    ///
    /// The `pksDismiss` closure is injected into the environment by the `PKSDismissModifier`.
    /// It allows views to perform a dismiss action using the navigation manager.
    var pksDismiss: () -> Void {
        get { self[PKSDismissKey.self] }
        set { self[PKSDismissKey.self] = newValue }
    }
}
