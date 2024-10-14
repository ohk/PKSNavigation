import SwiftUI
import PKSNavigation

struct AuthorDetail: View {
    @State var presentationDetents: Set<PresentationDetent> = [.medium]
    @EnvironmentObject var navigationManager: PKSNavigationManager
    @StateObject var authorNavigationManager: PKSNavigationManager = PKSNavigationManager(identifier: "Author Navigation Manager")
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 24) {
                    Image(systemName: "figure")
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .leading) {
                        Text("Joe Doe")
                            .font(.headline)
                        Text("joe@example.com")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("2 Articles published")
                    }
                }
                .fixedSize()
                
                VStack(alignment: .leading) {
                    Text("Articles")
                        .font(.headline)
                    ArticleRow(article: Array.mockData[0])
                    ArticleRow(article: Array.mockData[1])
                }
            }
            .padding()
            // It is only important when we are showing the sheet
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            if proxy.size.height > UIScreen.main.bounds.size.height * 0.7 {
                                presentationDetents = [.large]
                            } else {
                                presentationDetents = [.height(proxy.size.height)]
                            }
                        }
                }
            )
        }
        .presentationDetents(presentationDetents)
        // Navigation Manager Operations
        .onAppear {
            authorNavigationManager.setParent(navigationManager)
        }
    }
}
