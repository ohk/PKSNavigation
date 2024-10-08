import SwiftUI
import PKSNavigation

struct ContentView: View {
    @StateObject var homeNavigationManager = PKSNavigationManager(
        identifier: "Home Root Navigation Manager"
    )
    @StateObject var settingsNavigationManager = PKSNavigationManager(
        identifier: "Settings Root Navigation Manager"
    )
    
    var body: some View {
        TabView {
            HomeRootView()
                .environmentObject(homeNavigationManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SettingsRootView()
                .environmentObject(settingsNavigationManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}


