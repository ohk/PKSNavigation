//
//  PKSNavigationManager.swift
//  PKSNavigation
//
//  Created by Omer Hamid Kamisli on 2024-07-06 for POIKUS LLC.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//

import OSLog
import SwiftUI

/// Manages navigation within the application, handling different presentation methods such as stack, sheet, and cover.
///
/// The `PKSNavigationManager` class is responsible for controlling navigation flow in the app. It maintains navigation paths for different presentation styles and provides methods to navigate to new pages or navigate back. It also keeps track of navigation history and can work hierarchically with a parent navigation manager.
///
/// - Note: This class conforms to `ObservableObject` to allow SwiftUI views to react to changes in navigation state.
///
/// - Author: Omer Hamid Kamisli
open class PKSNavigationManager: ObservableObject {

    // MARK: - Published Properties

    /// The currently active presentation method.
    ///
    /// - Possible values:
    ///   - `.stack`: Navigation within a navigation stack.
    ///   - `.sheet`: Navigation presented modally as a sheet.
    ///   - `.cover`: Navigation presented modally as a full-screen cover.
    @Published private(set) var activePresentation: PKSPresentationMethod = .stack

    /// The navigation path for stack presentation.
    ///
    /// Used for navigating within a standard navigation stack.
    @Published public var rootPath: NavigationPath = .init()

    /// The navigation path for sheet presentation.
    ///
    /// Used for navigating within a modal sheet.
    @Published public var sheetPath: NavigationPath = .init()

    /// The navigation path for cover presentation.
    ///
    /// Used for navigating within a full-screen cover.
    @Published public var coverPath: NavigationPath = .init()

    /// The root view for sheet presentation.
    ///
    /// Represents the initial view when presenting modally as a sheet.
    @Published public var rootSheet: RootView? = nil

    /// The root view for cover presentation.
    ///
    /// Represents the initial view when presenting modally as a full-screen cover.
    @Published public var rootCover: RootView? = nil

    // MARK: - Parent Navigation Manager

    /// The parent navigation manager.
    ///
    /// Used to delegate navigation actions to a parent manager in a hierarchical navigation structure.
    public private(set) var parent: PKSNavigationManager?

    // MARK: - Private Properties

    /// The logger instance for logging navigation events.
    ///
    /// Uses the `OSLog` framework to log navigation-related messages for debugging purposes.
    private var logger: Logger

    /// The navigation history for the current navigation manager.
    ///
    /// Stores a stack of `PKSHistoryItem` instances representing the navigation history.
    private var history: PKSStack<PKSHistoryItem> = .init()

    /// A flag indicating whether the sheet stack is registered.
    ///
    /// Used to determine if the navigation manager can handle sheet presentations.
    private var isSheetStackRegistered: Bool = false

    /// A flag indicating whether the cover stack is registered.
    ///
    /// Used to determine if the navigation manager can handle cover presentations.
    private var isCoverStackRegistered: Bool = false

    // MARK: - Initialization

    /// Initializes a new `PKSNavigationManager` instance.
    ///
    /// - Parameter identifier: An optional identifier for the navigation manager, used in logging.
    public init(identifier: String = String(describing: PKSNavigationManager.self)) {
        logger = Logger(subsystem: "PKSNavigation", category: "Manager - \(identifier)")
        logger.debug("PKSNavigation created. \(identifier)")
    }

    deinit {
        logger.debug("PKSNavigation deinit. \(String(describing: type(of: self)))")
    }

    // MARK: - Parent Setter

    /// Sets the parent navigation manager.
    ///
    /// - Parameter parent: The parent `PKSNavigationManager` instance.
    public func setParent(_ parent: PKSNavigationManager?) {
        self.parent = parent
    }

    // MARK: - Navigation Methods

    /// Navigates to a specified page using a given presentation method.
    ///
    /// - Parameters:
    ///   - page: The destination page conforming to `PKSPage`.
    ///   - presentation: The presentation method to use. Defaults to `.stack`.
    ///   - isRoot: A Boolean indicating whether the page should be the root of the navigation stack. Defaults to `false`.
    public func navigate(to page: any PKSPage, presentation: PKSPresentationMethod = .stack, isRoot: Bool = false) {
        switch presentation {
        case .stack:
            handleStackNavigation(page: page)
        case .sheet:
            if isSheetStackRegistered {
                handleSheetNavigation(page: page, isRoot: isRoot)
            } else {
                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
            }
        case .cover:
            if isCoverStackRegistered {
                handleCoverNavigation(page: page, isRoot: isRoot)
            } else {
                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
            }
        }
    }

    /// Navigates back to the previous page in the navigation history.
    ///
    /// If there is no history in the current manager, it delegates the navigation back action to the parent manager.
    public func navigateBack() {
        guard let lastHistoryItem = history.pop() else {
            logger.debug("No history to navigate back to.")
            return
        }

        logger.debug("Navigating back from \(lastHistoryItem.page?.description ?? "unknown page").")

        switch lastHistoryItem.presentation {
        case .stack:
            if !rootPath.isEmpty {
                rootPath.removeLast()
            } else {
                parent?.navigateBack()
            }
        case .sheet:
            if !sheetPath.isEmpty {
                sheetPath.removeLast()
            } else {
                rootSheet = nil
            }
        case .cover:
            if !coverPath.isEmpty {
                coverPath.removeLast()
            } else {
                rootCover = nil
            }
        }

        updateActivePresentation()
    }

    /// Called when a modal is dismissed.
    ///
    /// Clears the navigation paths for the current modal presentation and resets the active presentation to `.stack`.
    public func onModalDismissed() {
        logger.debug("Modal dismissed.")
        if activePresentation == .sheet {
            sheetPath.clear()
        } else if activePresentation == .cover {
            coverPath.clear()
        }
        activePresentation = .stack
    }

    // MARK: - Registration Methods

    /// Registers the sheet stack.
    ///
    /// Indicates that the navigation manager can handle sheet presentations.
    public func registerSheetStack() {
        isSheetStackRegistered = true
    }

    /// Registers the cover stack.
    ///
    /// Indicates that the navigation manager can handle cover presentations.
    public func registerCoverStack() {
        isCoverStackRegistered = true
    }

    // MARK: - Private Methods

    /// Handles navigation when the presentation method is `.stack`.
    ///
    /// - Parameter page: The destination page to navigate to.
    private func handleStackNavigation(page: any PKSPage) {
        logNavigationEvent(page: page, presentation: .stack)
        activePresentation = .stack
        rootPath.append(page)
    }

    /// Handles navigation when the presentation method is `.sheet`.
    ///
    /// - Parameters:
    ///   - page: The destination page to navigate to.
    ///   - isRoot: A Boolean indicating whether the page should be the root of the sheet navigation stack.
    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
        logNavigationEvent(page: page, presentation: .sheet)
        activePresentation = .sheet
        if isRoot || rootSheet == nil {
            resetRootSheet(with: page)
        } else {
            sheetPath.append(page)
        }
    }

    /// Handles navigation when the presentation method is `.cover`.
    ///
    /// - Parameters:
    ///   - page: The destination page to navigate to.
    ///   - isRoot: A Boolean indicating whether the page should be the root of the cover navigation stack.
    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
        logNavigationEvent(page: page, presentation: .cover)
        activePresentation = .cover
        if isRoot || rootCover == nil {
            resetRootCover(with: page)
        } else {
            coverPath.append(page)
        }
    }

    /// Navigates using the parent navigation manager if the current manager cannot handle the navigation.
    ///
    /// - Parameters:
    ///   - page: The destination page to navigate to.
    ///   - presentation: The presentation method to use.
    ///   - isRoot: A Boolean indicating whether the page should be the root of the navigation stack.
    private func navigateWithParent(to page: any PKSPage, presentation: PKSPresentationMethod, isRoot: Bool) {
        history.push(
            PKSHistoryItem(
                page: page,
                presentation: presentation,
                timestamp: Date(),
                message: nil,
                isAppended: true,
                isParent: true
            )
        )
        parent?.navigate(to: page, presentation: presentation, isRoot: isRoot) ?? handleStackNavigation(page: page)
    }

    /// Resets the root sheet with the specified page.
    ///
    /// Handles iOS version differences and ensures the root sheet is properly set.
    ///
    /// - Parameter page: The page to set as the root of the sheet.
    private func resetRootSheet(with page: any PKSPage) {
        if #available(iOS 17, *) {
            sheetPath.clear()
            rootSheet = RootView(wrapped: page)
        } else {
            rootSheet = nil
            sheetPath.clear()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.rootSheet = RootView(wrapped: page)
            }
        }
    }

    /// Resets the root cover with the specified page.
    ///
    /// Handles iOS version differences and ensures the root cover is properly set.
    ///
    /// - Parameter page: The page to set as the root of the cover.
    private func resetRootCover(with page: any PKSPage) {
        if #available(iOS 17, *) {
            coverPath.clear()
            rootCover = RootView(wrapped: page)
        } else {
            rootCover = nil
            coverPath.clear()
            DispatchQueue.main.async { [weak self] in
                self?.rootCover = RootView(wrapped: page)
            }
        }
    }

    /// Updates the `activePresentation` property based on the navigation history.
    ///
    /// If the history is empty, sets `activePresentation` to `.stack`.
    private func updateActivePresentation() {
        if let lastHistoryItem = history.peek() {
            activePresentation = lastHistoryItem.presentation
        } else {
            activePresentation = .stack
        }
    }

    /// Logs a navigation event and updates the navigation history.
    ///
    /// - Parameters:
    ///   - page: The page involved in the navigation event.
    ///   - presentation: The presentation method used for navigation.
    private func logNavigationEvent(page: any PKSPage, presentation: PKSPresentationMethod) {
        history.push(
            PKSHistoryItem(
                page: page,
                presentation: presentation,
                timestamp: Date(),
                message: nil,
                isAppended: true,
                isParent: false
            )
        )
        logger.debug("Navigating to \(page.description) with \(presentation.rawValue) presentation.")
    }
}
