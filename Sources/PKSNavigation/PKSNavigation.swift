// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import OSLog

/// A class that manages navigation within the app, supporting stack, sheet, and cover presentations.
///
/// `PKSNavigationManager` provides functionality for navigating between different views using various presentation methods.
/// It maintains navigation paths for each presentation method and handles logging if enabled.
///
/// Example:
///
///     let navigationManager = PKSNavigationManager()
///     navigationManager.navigate(to: myPage, presentation: .sheet)
///
open class PKSNavigationManager: ObservableObject {

    /// The currently active presentation method.
    private(set) var activePresentation: PKSPresentationMethod = .stack

    /// The navigation path for stack presentation.
    @Published public var rootPath: NavigationPath = .init()

    /// The navigation path for sheet presentation.
    @Published public var sheetPath: NavigationPath = .init()

    /// The navigation path for cover presentation.
    @Published public var coverPath: NavigationPath = .init()

    /// The root view for sheet presentation.
    @Published public var rootSheet: RootView? = nil

    /// The root view for cover presentation.
    @Published public var rootCover: RootView? = nil

    /// The logger instance for logging navigation events.
    private var logger: Logger

    /// Initializes a new navigation manager.
    public init() {
        logger = Logger(subsystem: "PKSNavigation", category: String(describing: type(of: self)))
        logger.debug("PKSNavigation created. \(String(describing: type(of: self)))")
    }

    deinit {
        logger.debug("PKSNavigation deinit. \(String(describing: type(of: self)))")
    }

    private func handleStackNavigation(page: any PKSPage) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with stack presentation.")
        }
        activePresentation = .stack
        rootPath.append(page)
    }

    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with sheet presentation.")
        }
        activePresentation = .sheet

        if isRoot || rootSheet == nil {
            if rootSheet != nil {
                rootSheet = nil
                sheetPath.clear()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    self?.rootSheet = RootView(wrapped: page)
                }
            } else {
                rootSheet = RootView(wrapped: page)
            }
        } else {
            sheetPath.append(page)
        }
    }

    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with cover presentation.")
        }
        activePresentation = .cover

        if isRoot || rootCover == nil {
            if rootCover != nil {
                rootCover = nil
                rootPath.clear()
                DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                    self?.rootCover = RootView(wrapped: page)
                }
            } else {
                rootCover = RootView(wrapped: page)
            }
        } else {
            coverPath.append(page)
        }
    }

    /// Called when a modal is dismissed.
    public func onModalDismissed() {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Modal dismissed.")
        }
        if activePresentation == .sheet {
            sheetPath.clear()
        } else if activePresentation == .cover {
            coverPath.clear()
        }
    }

    /// Navigates to the specified page using the given presentation method.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - presentation: The method to use for presenting the page.
    ///   - isRoot: A Boolean value indicating whether the page should be the root of the navigation stack.
    public func navigate(
        to page: any PKSPage,
        presentation: PKSPresentationMethod = .stack,
        isRoot: Bool = false
    ) {
        switch activePresentation {
        case .stack:
            switch presentation {
            case .stack:
                handleStackNavigation(page: page)
            case .sheet:
                handleSheetNavigation(page: page, isRoot: isRoot)
            case .cover:
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
        case .sheet:
            handleSheetNavigation(page: page, isRoot: isRoot)
        case .cover:
            handleCoverNavigation(page: page, isRoot: isRoot)
        }
    }
}
