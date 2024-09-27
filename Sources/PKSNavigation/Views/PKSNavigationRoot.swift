//  NavigationDestinations.swift
//  PKSNavigation
//
//  Created by Omer Hamid Kamisli on 2024-09-18 for POIKUS LLC.
//  Copyright © 2024 POIKUS LLC. All rights reserved.
//

import SwiftUI

public struct PKSNavigationRoot<Root: View>: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager

    var root: Root

    // Escaping initializers
    public init(root: @escaping () -> Root) {
        self.root = root()
    }

    public var body: some View {
        NavigationStack(path: $navigationManager.rootPath) {
            root
                .environmentObject(navigationManager)
        }
        .sheet(item: $navigationManager.rootSheet, onDismiss: navigationManager.onModalDismissed) { page in
            NavigationStack(path: $navigationManager.sheetPath) {
                page.view
            }
            .onAppear {
                navigationManager.registerSheetStack()
            }
        }
        .fullScreenCover(item: $navigationManager.rootCover, onDismiss: navigationManager.onModalDismissed) { page in
            NavigationStack(path: $navigationManager.coverPath) {
                page.view
            }
            .onAppear {
                navigationManager.registerCoverStack()
            }
        }
    }
}

#Preview {
    PKSNavigationRoot {
        Text("Hello, World!")
    }
    .environmentObject(PKSNavigationManager())
}
