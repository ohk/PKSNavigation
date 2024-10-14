import SwiftUI

struct HomePage: View {
    var mockData: [Article] = .mockData
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                Section {
                    ForEach(mockData) { article in
                        ArticleRow(article: article)
                    }
                } header: {
                    Text("Articles")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
        }
    }
}
