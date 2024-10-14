import SwiftUI
import PKSNavigation

enum HomeTabNavigationablePages: PKSPage {
    case detail(article: Article, recommendations: [Article])
    
    var description: String {
        switch self {
        case .detail(let article, let recommendations):
            return "\(article.title) - \(recommendations.count)"
        }
    }
    
    var body: some View {
        switch self {
        case .detail(article: let article, recommendations: let recommendations):
            ArticleDetailView(article: article, recommendations: recommendations)
        }
    }

}
