////  NavigationDestinations.swift
////  PKSNavigation
////
////  Created by Omer Hamid Kamisli on 2024-07-06 for POIKUS LLC.
////  Copyright © 2024 POIKUS LLC. All rights reserved.
////
//
//import OSLog
//import SwiftUI
//
//open class PKSNavigationManager: ObservableObject {
//
//    /// The currently active presentation method.
//    @Published private(set) var activePresentation: PKSPresentationMethod = .stack
//
//    /// The navigation path for stack presentation.
//    @Published public var rootPath: NavigationPath = .init()
//
//    /// The navigation path for sheet presentation.
//    @Published public var sheetPath: NavigationPath = .init()
//
//    /// The navigation path for cover presentation.
//    @Published public var coverPath: NavigationPath = .init()
//
//    /// The root view for sheet presentation.
//    @Published public var rootSheet: RootView? = nil
//
//    /// The root view for cover presentation.
//    @Published public var rootCover: RootView? = nil
//
//    /// The parent navigation manager.
//    public private(set) var parent: PKSNavigationManager?
//
//    /// The logger instance for logging navigation events.
//    private var logger: Logger
//
//    /// The navigation history for the current navigation manager.
//    private var history: PKSStack<PKSHistoryItem> = .init()
//
//    /// A flag indicating whether the sheet stack is registered.
//    private var isSheetStackRegisted: Bool = false
//
//    /// A flag indicating whether the cover stack is registered.
//    private var isCoverStackRegisted: Bool = false
//
//    /// Initializes a new navigation manager instance.
//    ///
//    /// This initializer sets up the logger and initializes the class with the default values.
//    public init() {
//        let className = String(describing: type(of: self))
//        logger = Logger(subsystem: "PKSNavigation", category: className)
//        logger.debug("PKSNavigation created. \(className)")
//    }
//    
//    public init(identifier: String) {
//        logger = Logger(subsystem: "PKSNavigation", category: "Manager - \(identifier)")
//        logger.debug("PKSNavigation created. \(identifier)")
//    }
//
//    /// Sets the parent navigation manager.
//    ///
//    /// - Parameter parent: The parent navigation manager.
//    public func setParents(_ parent: PKSNavigationManager?) {
//        self.parent = parent
//    }
//
//    deinit {
//        logger.debug("PKSNavigation deinit. \(String(describing: type(of: self)))")
//    }
//
//    /// Adds a new page to the root navigation stack.
//    ///
//    /// - Parameter page: The page to navigate to.
//    private func handleStackNavigation(page: any PKSPage) {
//        history.push(
//            PKSHistoryItem(
//                page: page,
//                presentation: .stack,
//                timestamp: Date(),
//                message: nil,
//                isAppended: true,
//                isParent: false
//            )
//        )
//
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Navigating to \(page.description) with stack presentation.")
//        }
//        activePresentation = .stack
//        rootPath.append(page)
//    }
//
//    /// Adds a new page to the root sheet navigation stack.
//    ///
//    /// If the root sheet is not nil, the new page is added to the sheet path.
//    /// Otherwise, the root sheet is set to the new page.
//    ///
//    /// - Parameters:
//    ///   - page: The page to navigate to.
//    ///   - isRoot: A Boolean value indicating whether the page should be the root of the navigation stack.
//    /// - Returns: Void
//    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
//        history.push(
//            PKSHistoryItem(
//                page: page,
//                presentation: .sheet,
//                timestamp: Date(),
//                message: nil,
//                isAppended: true,
//                isParent: false
//            )
//        )
//
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Navigating to \(page.description) with sheet presentation.")
//        }
//        // If the active presentation is not sheet, set it to sheet.
//        if activePresentation != .sheet {
//            activePresentation = .sheet
//        }
//
//        if isRoot || rootSheet == nil {
//            if #available(iOS 17, *) {
//                if rootSheet != nil {
//                    sheetPath.clear()
//                }
//                rootSheet = RootView(wrapped: page)
//            } else {
//                // Workaround for iOS 16 bug affecting .sheet(item:) function.
//                if rootSheet != nil {
//                    rootSheet = nil
//                    sheetPath.clear()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
//                        self?.rootSheet = RootView(wrapped: page)
//                    }
//                } else {
//                    rootSheet = RootView(wrapped: page)
//                }
//            }
//        } else {
//            sheetPath.append(page)
//        }
//    }
//
//    /// Adds a new page to the root cover navigation stack.
//    ///
//    /// - Parameters:
//    ///   - page: The page to navigate to.
//    ///   - isRoot: A Boolean value indicating whether the page should be the root of the navigation stack.
//    /// - Returns: Void
//    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
//        history.push(
//            PKSHistoryItem(
//                page: page,
//                presentation: .cover,
//                timestamp: Date(),
//                message: nil,
//                isAppended: true,
//                isParent: false
//            )
//        )
//
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Navigating to \(page.description) with cover presentation.")
//        }
//
//        // If the active presentation is not cover, set it to cover.
//        if activePresentation != .cover {
//            activePresentation = .cover
//        }
//
//        if isRoot || rootCover == nil {
//            if #available(iOS 17, *) {
//                if rootCover != nil {
//                    coverPath.clear()
//                }
//                rootCover = RootView(wrapped: page)
//            } else {
//                // Workaround for iOS 16 bug affecting .cover(item:) function.
//                if rootCover != nil {
//                    rootCover = nil
//                    rootPath.clear()
//                    DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
//                        self?.rootCover = RootView(wrapped: page)
//                    }
//                } else {
//                    rootCover = RootView(wrapped: page)
//                }
//            }
//        } else {
//            coverPath.append(page)
//        }
//    }
//
//    private func navigateWithParent(
//        to page: any PKSPage,
//        presentation: PKSPresentationMethod = .stack,
//        isRoot: Bool = false
//    ) {
//        history.push(
//            PKSHistoryItem(
//                page: page,
//                presentation: presentation,
//                timestamp: Date(),
//                message: nil,
//                isAppended: true,
//                isParent: true
//            )
//        )
//        
//        if parent == nil {
//            handleStackNavigation(page: page)
//        } else {
//            parent?.navigate(to: page, presentation: presentation, isRoot: isRoot)
//        }
//    }
//
//    /// Called when a modal is dismissed.
//    public func onModalDismissed() {
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Modal dismissed.")
//        }
//        if activePresentation == .sheet {
//            sheetPath.clear()
//        } else if activePresentation == .cover {
//            coverPath.clear()
//        }
//
//        activePresentation = .stack
//    }
//
//    public func navigate(to page: any PKSPage, presentation: PKSPresentationMethod = .stack, isRoot: Bool = false) {
//        switch presentation {
//        case .stack:
//            switch parent?.activePresentation {
//            case .sheet:
//                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
//            case .cover:
//                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
//            default:
//                handleStackNavigation(page: page)
//            }
//        case .sheet:
//            if isSheetStackRegisted {
//                handleSheetNavigation(page: page, isRoot: isRoot)
//            } else {
//                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
//            }
//        case .cover:
//            if isCoverStackRegisted {
//                handleCoverNavigation(page: page, isRoot: isRoot)
//            } else {
//                navigateWithParent(to: page, presentation: presentation, isRoot: isRoot)
//            }
//        }
//    }
//
//
//    /// Navigates back to the previous page in the navigation stack.
//    func navigateBack() {
//        guard let lastHistoryItem = history.pop() else {
//            if PKSNavigationConfiguration.isLoggerEnabled {
//                logger.debug("No history to navigate back to.")
//            }
//            return
//        }
//        
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Navigating back from \(lastHistoryItem.page?.description ?? "").")
//        }
//        
//        switch lastHistoryItem.presentation {
//        case .stack:
//            if !rootPath.isEmpty {
//                rootPath.removeLast()
//            } else if let parent = parent {
//                parent.navigateBack()
//            }
//            
//        case .sheet:
//            if !sheetPath.isEmpty {
//                sheetPath.removeLast()
//                if sheetPath.isEmpty {
//                    rootSheet = nil
//                }
//            } else if let _ = rootSheet {
//                rootSheet = nil
//            } else if let parent = parent {
//                parent.navigateBack()
//            }
//            
//        case .cover:
//            if !coverPath.isEmpty {
//                coverPath.removeLast()
//                if coverPath.isEmpty {
//                    rootCover = nil
//                }
//            } else if let _ = rootCover {
//                rootCover = nil
//            } else if let parent = parent {
//                parent.navigateBack()
//            }
//        }
//        
//        // Update activePresentation based on the new history state
//        let activePresentation = updateActivePresentation()
//        
//        if PKSNavigationConfiguration.isLoggerEnabled {
//            logger.debug("Navigation back completed. Current active presentation: \(activePresentation.rawValue).")
//        }
//    }
//
//    
//    /// Updates the activePresentation based on the latest item in the history.
//    private func updateActivePresentation() -> PKSPresentationMethod {
//        if let lastHistoryItem = history.peek() {
//            activePresentation = lastHistoryItem.presentation
//            return lastHistoryItem.presentation
//        } else {
//            activePresentation = .stack
//            return .stack
//        }
//    }
//
//
//    /// Registers the sheet stack.
//    public func registerSheetStack() {
//        isSheetStackRegisted = true
//    }
//
//    /// Registers the cover stack.
//    public func registerCoverStack() {
//        isCoverStackRegisted = true
//    }
//}
