import SwiftUI

struct AuthorDetail: View {
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
        }
    }
}
