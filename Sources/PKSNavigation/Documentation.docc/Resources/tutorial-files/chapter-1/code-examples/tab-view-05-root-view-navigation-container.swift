import SwiftUI
import PKSNavigation

struct HomeRootView: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager
    
    var body: some View {
        PKSNavigationContainer(navigationManager: navigationManager) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}
