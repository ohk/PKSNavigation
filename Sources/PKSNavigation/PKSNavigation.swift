import SwiftUI
import OSLog

/// A class responsible for managing navigation within the app, supporting stack, sheet, and cover presentations.
///
/// `PKSNavigationManager` provides functionality for navigating between different views using various presentation methods.
/// It maintains navigation paths for each presentation method and handles logging if enabled.
///
/// Example usage:
///
/// ```swift
/// let navigationManager = PKSNavigationManager()
/// navigationManager.navigate(to: myPage, presentation: .sheet)
/// ```
///
/// The class maintains separate navigation paths for stack, sheet, and cover presentations, ensuring a seamless navigation experience.
///
/// - Author: Ömer Hamid Kamışlı
/// - Version: 1.0
///
open class PKSNavigationManager: ObservableObject {

    /// The currently active presentation method.
    @Published private(set) var activePresentation: PKSPresentationMethod = .stack

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
    
    /// The parent navigation manager.
    public private(set) var parent: PKSNavigationManager?
    
    /// The logger instance for logging navigation events.
    private var logger: Logger

    /// Initializes a new navigation manager instance.
    ///
    /// This initializer sets up the logger and initializes the class with the default values.
    public init() {
        let className = String(describing: type(of: self))
        logger = Logger(subsystem: "PKSNavigation", category: className)
        logger.debug("PKSNavigation created. \(className)")
    }

    /// Sets the parent navigation manager.
    ///
    /// - Parameter parent: The parent navigation manager.
    public func setParents(_ parent: PKSNavigationManager?) {
        self.parent = parent
    }

    deinit {
        logger.debug("PKSNavigation deinit. \(String(describing: type(of: self)))")
    }

    /// Adds a new page to the root navigation stack.
    ///
    /// - Parameter page: The page to navigate to.
    private func handleStackNavigation(page: any PKSPage) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with stack presentation.")
        }
        activePresentation = .stack
        rootPath.append(page)
    }

    /// Adds a new page to the root sheet navigation stack.
    ///
    /// If the root sheet is not nil, the new page is added to the sheet path.
    /// Otherwise, the root sheet is set to the new page.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: A Boolean value indicating whether the page should be the root of the navigation stack.
    /// - Returns: Void
    private func handleSheetNavigation(page: any PKSPage, isRoot: Bool) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with sheet presentation.")
        }
        // If the active presentation is not sheet, set it to sheet.
        if activePresentation != .sheet {
            activePresentation = .sheet
        }

        if isRoot || rootSheet == nil {
            if #available(iOS 17, *) {
                if rootSheet != nil {
                    sheetPath.clear()
                }
                rootSheet = RootView(wrapped: page)
            } else {
                // Workaround for iOS 16 bug affecting .sheet(item:) function.
                if rootSheet != nil {
                    rootSheet = nil
                    sheetPath.clear()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                        self?.rootSheet = RootView(wrapped: page)
                    }
                } else {
                    rootSheet = RootView(wrapped: page)
                }
            }
        } else {
            sheetPath.append(page)
        }
    }

    /// Adds a new page to the root cover navigation stack.
    ///
    /// - Parameters:
    ///   - page: The page to navigate to.
    ///   - isRoot: A Boolean value indicating whether the page should be the root of the navigation stack.
    /// - Returns: Void
    private func handleCoverNavigation(page: any PKSPage, isRoot: Bool) {
        if PKSNavigationConfiguration.isLoggerEnabled {
            logger.debug("Navigating to \(page.description) with cover presentation.")
        }

        // If the active presentation is not cover, set it to cover.
        if activePresentation != .cover {
            activePresentation = .cover
        }

        if isRoot || rootCover == nil {
            if #available(iOS 17, *) {
                if rootCover != nil {
                    coverPath.clear()
                }
                rootCover = RootView(wrapped: page)
            } else {
                // Workaround for iOS 16 bug affecting .cover(item:) function.
                if rootCover != nil {
                    rootCover = nil
                    rootPath.clear()
                    DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                        self?.rootCover = RootView(wrapped: page)
                    }
                } else {
                    rootCover = RootView(wrapped: page)
                }
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
        switch parent?.activePresentation {
        case .stack:
            parent?.navigate(to: page, presentation: presentation, isRoot: isRoot)
        case .sheet:
            switch presentation {
            case .stack, .sheet:
                parent?.navigate(to: page, presentation: presentation, isRoot: isRoot)
            case .cover:
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
        case .cover:
            switch presentation {
            case .stack, .cover:
                parent?.navigate(to: page, presentation: presentation, isRoot: isRoot)
            case .sheet:
                handleCoverNavigation(page: page, isRoot: isRoot)
            }
        case nil:
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
}
