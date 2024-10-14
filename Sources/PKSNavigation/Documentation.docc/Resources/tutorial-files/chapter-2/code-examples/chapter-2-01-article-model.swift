import Foundation

struct Article: Identifiable, Hashable, Equatable {
    let id = UUID()
    let title: String
    let author: String
    let date: String
    let summary: String
    let description: [String]
    let imageName: String
}
