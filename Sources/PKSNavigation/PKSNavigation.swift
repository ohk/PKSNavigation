//
//  PKSNavigationManager.swift
//  PKSNavigation
//
//  Created by Omer Hamid Kamisli on 2024-07-06 for POIKUS LLC.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//

import OSLog
import SwiftUI

/// Manages the navigation flow within the PKSNavigation framework.
///
/// The `PKSNavigationManager` class is responsible for handling navigation actions such as pushing and popping views,
/// managing different presentation methods (stack, sheet, cover), and maintaining navigation history.
/// It allows for nested navigation by supporting a parent navigation manager and ensures that navigation
/// state changes are observed by conforming to `ObservableObject`.
///
/// - Note: This class is `open` and can be subclassed to extend its functionality.
///
/// - Author: Omer Hamid Kamisli
open class PKSNavigationManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The currently active presentation method.
    ///
    /// Indicates the presentation method currently in use, such as `.stack`, `.sheet`, or `.cover`.
    @Published private(set) var activePresentation: PKSPresentationMethod = .stack
    
    /// The navigation path for stack-based navigation.
    ///
    /// Used to manage the navigation stack when using the `.stack` presentation method.
    @Published public var rootPath: NavigationPath = .init()
    
    /// The navigation path for sheet presentations.
    ///
    /// Manages the navigation stack when presenting views as sheets.
    @Published public var sheetPath: NavigationPath = .init()
    
    /// The navigation path for cover presentations.
    ///
    /// Manages the navigation stack when presenting views as full-screen covers.
    @Published public var coverPath: NavigationPath = .init()
    
    /// The root view for sheet presentations.
    ///
    /// Represents the initial view presented as a sheet.
    @Published public var rootSheet: PKSView? = nil
    
    /// The root view for cover presentations.
    ///
    /// Represents the initial view presented as a full-screen cover.
    @Published public var rootCover: PKSView? = nil
    
    // MARK: - Properties
    
    /// The parent navigation manager.
    ///
    /// Used for nested navigation flows, allowing this manager to delegate navigation actions to a parent manager.
    public private(set) var parent: PKSNavigationManager?
    
    /// The logger used for debugging and monitoring navigation events.
    private var logger: Logger
    
    /// The navigation history stack.
    ///
    /// Stores a history of navigation events to manage backward navigation and state restoration.
    private var history: PKSStack<PKSHistoryItem> = .init()
    
    /// A flag indicating whether the sheet stack has been registered.
    private var isSheetStackRegistered: Bool = false
    
    /// A flag indicating whether the cover stack has been registered.
    private var isCoverStackRegistered: Bool = false
    
    /// A unique identifier for the navigation manager.
    private var identifier: String
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `PKSNavigationManager`.
    ///
    /// - Parameter identifier: A unique identifier for the navigation manager. Defaults to the class name.
    public init(identifier: String = String(describing: PKSNavigationManager.self)) {
        self.identifier = identifier
        logger = Logger(subsystem: "PKSNavigation", category: "Manager - \(identifier)")
        logger.debug("PKSNavigation created. \(identifier)")
    }
    
    deinit {
        logger.debug("PKSNavigation deinit. \(String(describing: type(of: self)))")
    }
    
    // MARK: - Public Methods
    
    /// Sets the parent navigation manager.
    ///
    /// Use this method to establish a hierarchical navigation structure by assigning a parent manager.
    ///
    /// - Parameter parent: The parent `PKSNavigationManager` instance.
    public func setParent(_ parent: PKSNavigationManager?) {
        self.parent = parent
    }
    
    /// Navigates to a specified page using a given presentation method.
    ///
    /// This method handles navigation to a new page, managing different presentation styles such as stack navigation,
    /// sheet presentation, or full-screen cover. It also updates the navigation history accordingly.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to, conforming to `PKSPage`.
    ///   - presentation: The presentation method to use. Options are `.stack`, `.sheet`, or `.cover`. Defaults to `.stack`.
    ///   - isRoot: A Boolean value indicating whether the page should be set as the root of the navigation stack. Defaults to `false`.
    public func navigate(to page: any PKSPage, presentation: PKSPresentationMethod = .stack, isRoot: Bool = false) {
        switch presentation {
        case .stack:
            switch activePresentation {
            case .stack:
                if let parent {
                    navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
                } else {
                    handleStackNavigation(page: page)
                }
            case .sheet:
                handleSheetNavigation(page: page, isRoot: isRoot)
            case .cover:
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
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
    /// This method pops the last navigation event from the history stack and updates the navigation state accordingly.
    /// If there is no history, it delegates the navigation back action to the parent manager if available.
    public func navigateBack() {
        guard let lastHistoryItem = history.pop() else {
            logger.critical("No history to navigate back to.")
            return
        }
        
        if lastHistoryItem.isParent {
            parent?.navigateBack()
        } else {
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
    }
    
    /// Called when a modal is dismissed.
    ///
    /// This method resets the navigation paths for sheet and cover presentations and updates the active presentation method.
    public func onModalDismissed() {
        logger.debug("Modal dismissed.")
        if activePresentation == .sheet {
            sheetPath.clear()
        } else if activePresentation == .cover {
            coverPath.clear()
        }
        activePresentation = .stack
    }
    
    /// Registers the sheet stack for navigation.
    ///
    /// Call this method to enable sheet-based navigation within the manager.
    public func registerSheetStack() {
        isSheetStackRegistered = true
    }
    
    /// Registers the cover stack for navigation.
    ///
    /// Call this method to enable cover-based navigation within the manager.
    public func registerCoverStack() {
        isCoverStackRegistered = true
    }
    
    /// Terminates the current navigation flow and returns to the parent or root.
    ///
    /// This method clears the navigation history and delegates the termination action to the parent manager if available.
    public func killTheFlow() {
        while let historyItem = history.pop() {
            if historyItem.isParent {
                parent?.navigateBack()
            } else {
                navigateBack()
            }
        }
        parent?.navigateBack()
    }
    
    // MARK: - Private Methods
    
    /// Handles stack-based navigation.
    ///
    /// - Parameter page: The page to navigate to.
    private func handleStackNavigation(page: any PKSPage) {
        if parent == nil {
            logNavigationEvent(page: page, presentation: .stack)
            activePresentation = .stack
            rootPath.append(PKSView(wrapped: page))
        } else {
            navigateWithParent(to: page, presentation: .stack, isRoot: false)
        }
    }
    
    /// Handles sheet-based navigation.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: Indicates whether the page should be set as the root of the sheet navigation stack.
    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
        logNavigationEvent(page: page, presentation: .sheet)
        activePresentation = .sheet
        if isRoot || rootSheet == nil {
            resetRootSheet(with: page)
        } else {
            sheetPath.append(PKSView(wrapped: page))
        }
    }
    
    /// Handles cover-based navigation.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: Indicates whether the page should be set as the root of the cover navigation stack.
    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
        logNavigationEvent(page: page, presentation: .cover)
        activePresentation = .cover
        if isRoot || rootCover == nil {
            resetRootCover(with: page)
        } else {
            coverPath.append(PKSView(wrapped: page))
        }
    }
    
    /// Navigates using the parent navigation manager.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - presentation: The presentation method to use.
    ///   - isRoot: Indicates whether the page should be set as the root of the navigation stack.
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
    
    /// Resets the root sheet with a new page.
    ///
    /// - Parameter page: The new root page for sheet presentations.
    private func resetRootSheet(with page: any PKSPage) {
        if #available(iOS 17, *) {
            sheetPath.clear()
            rootSheet = PKSView(wrapped: page)
        } else {
            rootSheet = nil
            sheetPath.clear()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.rootSheet = PKSView(wrapped: page)
            }
        }
    }
    
    /// Resets the root cover with a new page.
    ///
    /// - Parameter page: The new root page for cover presentations.
    private func resetRootCover(with page: any PKSPage) {
        if #available(iOS 17, *) {
            coverPath.clear()
            rootCover = PKSView(wrapped: page)
        } else {
            rootCover = nil
            coverPath.clear()
            DispatchQueue.main.async { [weak self] in
                self?.rootCover = PKSView(wrapped: page)
            }
        }
    }
    
    /// Updates the active presentation method based on the navigation history.
    private func updateActivePresentation() {
        if let lastHistoryItem = history.peek() {
            activePresentation = lastHistoryItem.presentation
        } else {
            activePresentation = .stack
        }
    }
    
    /// Logs a navigation event and updates the history.
    ///
    /// - Parameters:
    ///   - page: The page being navigated to.
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
