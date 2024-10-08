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
        logger.debug("PKSNavigationManager initialized with identifier: \(identifier).")
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
        if let parent = parent {
            logger.debug(
                "Parent navigation manager set to \(String(describing: parent.identifier)).")
        } else {
            logger.debug("Parent navigation manager removed.")
        }
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
    func navigate(to page: any PKSPage, presentation: PKSPresentationMethod = .stack, isRoot: Bool = false) {
        logger.debug(
            "Request to navigate to \(page.description) with presentation: \(presentation.rawValue), isRoot: \(isRoot)."
        )
        
        switch presentation {
        case .stack:
            switch activePresentation {
            case .stack:
                handleStackNavigation(page: page)
            case .sheet:
                logger.debug("Current active presentation is sheet. Handling stack navigation within sheet.")
                handleSheetNavigation(page: page, isRoot: isRoot)
            case .cover:
                logger.debug("Current active presentation is cover. Handling stack navigation within cover.")
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
        case .sheet:
            if isSheetStackRegistered {
                handleSheetNavigation(page: page, isRoot: isRoot)
            } else {
                logger.debug("Sheet stack not registered. Delegating sheet navigation to parent.")
                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
            }
        case .cover:
            if isCoverStackRegistered {
                handleCoverNavigation(page: page, isRoot: isRoot)
            } else {
                logger.debug("Cover stack not registered. Delegating cover navigation to parent.")
                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
            }
        }
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
    ///   - isNavigatingWithParent: A Boolean value indicating whether the navigation passed from sub manager to parent manager. Defaults to `false`
    fileprivate func navigate(to page: any PKSPage, presentation: PKSPresentationMethod = .stack, isRoot: Bool = false, isNavigatingWithParent: Bool = false) {
        if !isNavigatingWithParent {
            logger.debug(
                "Request to navigate to \(page.description) with presentation: \(presentation.rawValue), isRoot: \(isRoot)."
            )
        }
        switch presentation {
        case .stack:
            switch activePresentation {
            case .stack:
                handleStackNavigation(page: page)
            case .sheet:
                logger.debug("Current active presentation is sheet. Handling stack navigation within sheet.")
                handleSheetNavigation(page: page, isRoot: isRoot)
            case .cover:
                logger.debug("Current active presentation is cover. Handling stack navigation within cover.")
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
        case .sheet:
            if isSheetStackRegistered {
                handleSheetNavigation(page: page, isRoot: isRoot)
            } else {
                logger.debug("Sheet stack not registered. Delegating sheet navigation to parent.")
                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
            }
        case .cover:
            if isCoverStackRegistered {
                handleCoverNavigation(page: page, isRoot: isRoot)
            } else {
                logger.debug("Cover stack not registered. Delegating cover navigation to parent.")
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
            logger.critical("No history available to navigate back.")
            return
        }
        if !lastHistoryItem.isParent {
            logger.debug("Attempting to navigate back.")
            logger.debug("Popped history item: \(String(describing: lastHistoryItem.page?.description)).")
        }
        
        if lastHistoryItem.isParent {
            logger.debug("History item belongs to parent. Delegating navigateBack to parent.")
            parent?.navigateBack()
        } else {
            logger.debug("Handling navigateBack for presentation: \(lastHistoryItem.presentation.rawValue).")
            switch lastHistoryItem.presentation {
            case .stack:
                if !rootPath.isEmpty {
                    rootPath.removeLast()
                    logger.debug("Removed last item from rootPath. New stack depth: \(self.rootPath.count).")
                } else {
                    logger.warning("rootPath is empty.")
                }
            case .sheet:
                if !sheetPath.isEmpty {
                    sheetPath.removeLast()
                    logger.debug("Removed last item from sheetPath. New sheet depth: \(self.sheetPath.count).")
                } else {
                    logger.debug("Clearing rootSheet.")
                    rootSheet = nil
                }
            case .cover:
                if !coverPath.isEmpty {
                    coverPath.removeLast()
                    logger.debug("Removed last item from coverPath. New cover depth: \(self.coverPath.count).")
                } else {
                    logger.debug("Clearing rootCover.")
                    rootCover = nil
                }
            }
            updateActivePresentation()
            logger.debug(
                "navigateBack completed for presentation: \(lastHistoryItem.presentation.rawValue)."
            )
        }
    }
    
    /// Called when a sheet modal is dismissed.
    ///
    /// This method resets the navigation paths for sheet presentations and updates the active presentation method.
    public func onSheetModalDismissed() {
        logger.debug(
            "Sheet modal dismissed. Resetting navigation paths based on active presentation: \(self.activePresentation.rawValue)."
        )

        logger.debug("Popping history items until a non-sheet presentation is found.")
        var popCount = 0

        while let historyItem = history.peek(), historyItem.presentation == .sheet {
            history.pop()
            popCount += 1
        }

        sheetPath.clear()
        logger.debug("sheetPath cleared. Popped \(popCount) history items.")

        activePresentation = .stack
        logger.debug("Active presentation set to .stack after modal dismissal.")
    }
    
    /// Called when a cover modal is dismissed.
    ///
    /// This method resets the navigation paths for cover presentations and updates the active presentation method.
    public func onCoverModalDismissed() {
        logger.debug(
            "Cover modal dismissed. Resetting navigation paths based on active presentation: \(self.activePresentation.rawValue)."
        )

        logger.debug("Popping history items until a non-cover presentation is found.")
        var popCount = 0

        while let historyItem = history.peek(), historyItem.presentation == .cover {
            history.pop()
            popCount += 1
        }

        coverPath.clear()
        logger.debug("coverPath cleared. Popped \(popCount) history items.")
    
        activePresentation = .stack
        logger.debug("Active presentation set to .stack after modal dismissal.")
    }

    /// Registers the sheet stack for navigation.
    ///
    /// Call this method to enable sheet-based navigation within the manager.
    public func registerSheetStack() {
        isSheetStackRegistered = true
        logger.debug("Sheet stack has been registered.")
    }

    /// Registers the cover stack for navigation.
    ///
    /// Call this method to enable cover-based navigation within the manager.
    public func registerCoverStack() {
        isCoverStackRegistered = true
        logger.debug("Cover stack has been registered.")
    }

    /// Terminates the current navigation flow and returns to the parent or root.
    ///
    /// This method clears the navigation history and delegates the termination action to the parent manager if available.
    public func killTheFlow() {
        logger.warning("Killing the current navigation flow. Clearing history.")
        while let historyItem = history.peek() {
            logger.debug(
                "Clearing history item: \(String(describing: historyItem.page?.description)).")
            if historyItem.isParent {
                logger.debug("History item belongs to parent. Delegating navigateBack to parent.")
                parent?.navigateBack()
            } else {
                navigateBack()
            }
        }
        logger.debug("All history items cleared. Finalizing killTheFlow.")
        parent?.navigateBack()
        logger.info("killTheFlow completed. Returned to parent or root.")
    }

    // MARK: - Private Methods

    /// Handles stack-based navigation.
    ///
    /// - Parameter page: The page to navigate to.
    private func handleStackNavigation(page: any PKSPage) {
        logger.debug("Handling stack navigation for page: \(page.description).")
        if parent == nil {
            logNavigationEvent(page: page, presentation: .stack)
            activePresentation = .stack
            rootPath.append(PKSView(wrapped: page))
            logger.info(
                "Navigated to \(page.description) on stack. Stack depth: \(self.rootPath.count).")
        } else {
            logger.debug("Parent exists. Delegating stack navigation to parent.")
            navigateWithParent(to: page, presentation: .stack, isRoot: false)
        }
    }

    /// Handles sheet-based navigation.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: Indicates whether the page should be set as the root of the sheet navigation stack.
    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
        logger.debug("Handling sheet navigation for page: \(page.description), isRoot: \(isRoot).")
        logNavigationEvent(page: page, presentation: .sheet)
        activePresentation = .sheet
        if isRoot || rootSheet == nil {
            logger.debug("Setting new root sheet with page: \(page.description).")
            resetRootSheet(with: page)
        } else {
            logger.debug("Appending to sheetPath with page: \(page.description).")
            sheetPath.append(PKSView(wrapped: page))
        }
        logger.info(
            "Sheet navigation to \(page.description) completed. Sheet depth: \(self.sheetPath.count).")
    }

    /// Handles cover-based navigation.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: Indicates whether the page should be set as the root of the cover navigation stack.
    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
        logger.debug("Handling cover navigation for page: \(page.description), isRoot: \(isRoot).")
        logNavigationEvent(page: page, presentation: .cover)
        activePresentation = .cover
        if isRoot || rootCover == nil {
            logger.debug("Setting new root cover with page: \(page.description).")
            resetRootCover(with: page)
        } else {
            logger.debug("Appending to coverPath with page: \(page.description).")
            coverPath.append(PKSView(wrapped: page))
        }
        logger.info(
            "Cover navigation to \(page.description) completed. Cover depth: \(self.coverPath.count).")
    }

    /// Navigates using the parent navigation manager.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - presentation: The presentation method to use.
    ///   - isRoot: Indicates whether the page should be set as the root of the navigation stack.
    private func navigateWithParent(
        to page: any PKSPage, presentation: PKSPresentationMethod, isRoot: Bool
    ) {
        logger.debug(
            "Navigating with parent for page: \(page.description), presentation: \(presentation.rawValue), isRoot: \(isRoot)."
        )
        history.push(
            PKSHistoryItem(
                page: page,
                presentation: presentation,
                timestamp: Date(),
                message: "Navigated with parent",
                isAppended: true,
                isParent: true
            )
        )
        parent?.navigate(to: page, presentation: presentation, isRoot: isRoot)
            ?? handleStackNavigation(page: page)
        logger.info("navigateWithParent executed for page: \(page.description).")
    }

    /// Resets the root sheet with a new page.
    ///
    /// - Parameter page: The new root page for sheet presentations.
    private func resetRootSheet(with page: any PKSPage) {
        logger.debug("Resetting root sheet with page: \(page.description).")
        if #available(iOS 17, *) {
            sheetPath.clear()
            rootSheet = PKSView(wrapped: page)
            logger.debug("Root sheet reset immediately for iOS 17 and above.")
        } else {
            rootSheet = nil
            sheetPath.clear()
            logger.debug(
                "Cleared rootSheet and sheetPath for iOS versions below 17. Scheduling rootSheet update."
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else {
                    self?.logger.error("Self is nil when resetting root sheet.")
                    return
                }
                self.rootSheet = PKSView(wrapped: page)
                self.logger.debug("Root sheet reset asynchronously for iOS below 17.")
            }
        }
    }

    /// Resets the root cover with a new page.
    ///
    /// - Parameter page: The new root page for cover presentations.
    private func resetRootCover(with page: any PKSPage) {
        logger.debug("Resetting root cover with page: \(page.description).")
        if #available(iOS 17, *) {
            coverPath.clear()
            rootCover = PKSView(wrapped: page)
            logger.debug("Root cover reset immediately for iOS 17 and above.")
        } else {
            rootCover = nil
            coverPath.clear()
            logger.debug(
                "Cleared rootCover and coverPath for iOS versions below 17. Scheduling rootCover update."
            )
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    self?.logger.error("Self is nil when resetting root cover.")
                    return
                }
                self.rootCover = PKSView(wrapped: page)
                self.logger.debug("Root cover reset asynchronously for iOS below 17.")
            }
        }
    }

    /// Updates the active presentation method based on the navigation history.
    private func updateActivePresentation() {
        if let lastHistoryItem = history.peek() {
            logger.debug(
                "Updating active presentation to \(lastHistoryItem.presentation.rawValue) based on history."
            )
            activePresentation = lastHistoryItem.presentation
        } else {
            logger.debug("No history available. Setting active presentation to .stack.")
            activePresentation = .stack
        }
    }

    /// Logs a navigation event and updates the history.
    ///
    /// - Parameters:
    ///   - page: The page being navigated to.
    ///   - presentation: The presentation method used for navigation.
    private func logNavigationEvent(page: any PKSPage, presentation: PKSPresentationMethod) {
        logger.debug(
            "Logging navigation event for page: \(page.description), presentation: \(presentation.rawValue)."
        )
        history.push(
            PKSHistoryItem(
                page: page,
                presentation: presentation,
                timestamp: Date(),
                message: "Navigation event logged",
                isAppended: true,
                isParent: false
            )
        )
        logger.debug(
            "Navigated to \(page.description) with \(presentation.rawValue) presentation. History size: \(self.history.count)."
        )
    }
}
