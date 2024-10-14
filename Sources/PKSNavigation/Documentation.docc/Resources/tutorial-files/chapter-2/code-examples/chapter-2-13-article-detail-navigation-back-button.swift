import SwiftUI
import PKSNavigation

struct ArticleDetailView: View {
    @EnvironmentObject var navigationManager: PKSNavigationManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.pksDismiss) var dismiss
    
    let article: Article
    let recommendations: [Article]
    
    var body: some View {
        Section {
            ScrollView(.vertical) {
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(article.description, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    recommendationsView
                }
            }
        } header: {
            header
        }
        .toolbar(.hidden)
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "arrow.left")
                    .font(.headline)
                    .onTapGesture {
                        dismiss()
                    }
                
                Text(article.title)
                    .font(.title)
                    .bold()
            }

            Text("by \(article.author) • \(article.date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func RecommendationCard(_ recommendation: Article) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recommendation.title)
                .font(.headline)
                .bold()
            
            Text("by \(recommendation.author) • \(recommendation.date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.init(.systemGray3))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.init(.systemGray5))
        }
        .padding(.trailing, 16)
    }
    
    private var recommendationsView: some View {
        Section(header: Text("Recommended Articles").font(.headline).padding()) {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 16)
                    ForEach(recommendations, id: \.id) { recommendation in
                        RecommendationCard(recommendation)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationManager.navigate(to: HomeTabNavigationablePages.detail(
                                    article: recommendation,
                                    recommendations: .mockData
                                ))
                            }
                    }
                }
            }
        }
    }
}
