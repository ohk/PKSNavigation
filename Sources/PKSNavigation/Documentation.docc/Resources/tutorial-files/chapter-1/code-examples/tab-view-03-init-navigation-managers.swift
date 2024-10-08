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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
