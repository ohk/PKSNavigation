import SwiftUI
import PKSNavigation

enum HomeTabNavigationablePages: PKSPage {
    case detail(article: Article, recommendations: [Article])
    case authorDetail
    
    var description: String {
        switch self {
        case .detail(let article, let recommendations):
            return "\(article.title) - \(recommendations.count)"
        case .authorDetail:
            return "Author Detail"
        }
    }
    
    var body: some View {
        switch self {
        case .detail(article: let article, recommendations: let recommendations):
            ArticleDetailView(article: article, recommendations: recommendations)
        case .authorDetail:
            AuthorDetail()
        }
    }
}
