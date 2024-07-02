//
//  PKSNavigationConfiguration.swift
//
//
//  Created by Ömer Hamid Kamışlı on 7/1/24.
//

import SwiftUI

/// A singleton class that manages navigation configuration settings for your app.
///
/// `PKSNavigationConfiguration` provides a centralized configuration for
/// navigation-related settings, such as enabling or disabling logging. This class
/// follows the singleton pattern, ensuring a single instance is used throughout
/// the app.
///
/// Example:
///
///     PKSNavigationConfiguration.enableLogger()
///
public class PKSNavigationConfiguration: ObservableObject {

    /// The shared instance of the navigation configuration.
    static var shared: PKSNavigationConfiguration = .init()
    
    /// A Boolean value indicating whether logging is enabled.
    ///
    /// Use the `enableLogger` and `disableLogger` methods to change this value.
    public private(set) static var isLoggerEnabled: Bool = true
    
    /// Private initializer to enforce the singleton pattern.
    private init() {}

    /// Enables logging.
    public static func enableLogger() {
        PKSNavigationConfiguration.isLoggerEnabled = true
    }
    
    /// Disables logging.
    public static func disableLogger() {
        PKSNavigationConfiguration.isLoggerEnabled = false
    }
}
