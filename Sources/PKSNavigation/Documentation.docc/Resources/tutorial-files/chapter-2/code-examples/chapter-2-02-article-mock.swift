import Foundation

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let date: String
    let summary: String
    let description: [String]
    let imageName: String
}

extension Article {
    static var mock: Article {
        Article(
            title: "Understanding SwiftUI",
            author: "Jane Doe",
            date: "October 1, 2023",
            summary: "An in-depth exploration of SwiftUI for building modern iOS applications.",
            description: [
                "SwiftUI is a powerful framework introduced by Apple that allows developers to build user interfaces across all Apple platforms with the power of Swift. It provides a declarative syntax, making UI development more intuitive and efficient.",
                "In this article, we'll delve into the basics of SwiftUI, explore its core components, and understand how it simplifies the process of creating dynamic and responsive user interfaces."
            ],
            imageName: "swiftui"
        )
    }
}

extension Array where Element == Article {
    static var mockData: [Article] {
        [
            Article(
                title: "Understanding SwiftUI",
                author: "Jane Doe",
                date: "October 1, 2023",
                summary: "An in-depth exploration of SwiftUI for building modern iOS applications.",
                description: [
                    "SwiftUI is a powerful framework introduced by Apple that allows developers to build user interfaces across all Apple platforms with the power of Swift. It provides a declarative syntax, making UI development more intuitive and efficient.",
                    "In this article, we'll delve into the basics of SwiftUI, explore its core components, and understand how it simplifies the process of creating dynamic and responsive user interfaces."
                ],
                imageName: "swiftui"
            ),
            Article(
                title: "Combine Framework Basics",
                author: "John Smith",
                date: "September 25, 2023",
                summary: "Learn the fundamentals of Apple's Combine framework for reactive programming.",
                description: [
                    "Combine is Apple's declarative framework for handling asynchronous events by combining event-processing operators. It provides a unified approach to handling events from different sources like UI controls, network responses, and more.",
                    "This article covers the basics of Combine, including publishers, subscribers, and operators, helping you get started with reactive programming in your iOS applications."
                ],
                imageName: "combine"
            ),
            Article(
                title: "Mastering iOS Animations",
                author: "Emily Clark",
                date: "September 15, 2023",
                summary: "Enhance your apps with smooth and interactive animations.",
                description: [
                    "Animations play a crucial role in enhancing user experience by providing visual feedback and making interactions feel more natural. iOS offers a robust set of tools for creating animations that can make your app stand out.",
                    "In this comprehensive guide, we'll explore various animation techniques in iOS, including implicit and explicit animations, spring animations, and keyframe animations."
                ],
                imageName: "animation"
            ),
            // Additional Mock Articles
            Article(
                title: "Networking in SwiftUI",
                author: "Michael Brown",
                date: "October 5, 2023",
                summary: "Implementing network requests and handling data in SwiftUI applications.",
                description: [
                    "Networking is a fundamental aspect of most modern applications. SwiftUI, combined with Swift's powerful networking capabilities, allows developers to fetch and display data seamlessly.",
                    "This article walks you through setting up network requests, parsing JSON data, and updating your SwiftUI views based on the received data."
                ],
                imageName: "networking"
            ),
            Article(
                title: "State Management in SwiftUI",
                author: "Laura Wilson",
                date: "October 10, 2023",
                summary: "Managing state effectively in SwiftUI to create dynamic interfaces.",
                description: [
                    "State management is critical in building responsive and dynamic user interfaces. SwiftUI offers various property wrappers like `@State`, `@Binding`, `@ObservedObject`, and `@EnvironmentObject` to handle state changes efficiently.",
                    "In this article, we'll explore different state management techniques in SwiftUI, their appropriate use cases, and best practices to maintain a clean and manageable codebase."
                ],
                imageName: "state"
            ),
            Article(
                title: "Integrating Core Data with SwiftUI",
                author: "Sophia Martinez",
                date: "October 12, 2023",
                summary: "Persisting data in SwiftUI applications using Core Data.",
                description: [
                    "Core Data is Apple's framework for managing object graphs and persisting data. Integrating Core Data with SwiftUI allows for robust data management within your applications.",
                    "This guide covers setting up Core Data in a SwiftUI project, performing CRUD operations, and displaying persisted data within your SwiftUI views."
                ],
                imageName: "coredata"
            ),
            Article(
                title: "Building Custom Views in SwiftUI",
                author: "David Lee",
                date: "October 15, 2023",
                summary: "Creating reusable and customizable views to streamline your SwiftUI development.",
                description: [
                    "Custom views promote reusability and maintainability in your SwiftUI projects. By encapsulating UI components, you can create modular and flexible interfaces.",
                    "This article demonstrates how to build custom views, pass data between them, and apply modifiers to enhance their functionality and appearance."
                ],
                imageName: "customviews"
            )
        ]
    }
}
