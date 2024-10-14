import SwiftUI

struct ArticleRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    let article: Article
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "doc.text")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(colorScheme == .dark ? .white : .blue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("by \(article.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(article.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(article.summary)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.init(.systemGray4))
        }
    }
}
