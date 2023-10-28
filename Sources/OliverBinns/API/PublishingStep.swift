import Foundation
import Publish

extension PublishingStep where Site == OliverBinns {
    static var generateAPI: Self {
        .group([
            generateJSONList,
            outputPosts
        ])
    }

    private static var generateJSONList: Self {
        .step(named: "API List", body: { context in
            let file = try context.createOutputFile(at: "api/posts.json")
            let items = context.sections[.posts].items.map(PostJSON.init)
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData = try encoder.encode(items)
            try file.append(encodedData)
        })
    }

    private static var outputPosts: Self {
        .step(named: "Copy Posts") { context in
            try context.folder(at: "Content/posts")
                .files
                .map { file in
                    let data = try file
                        .readAsString()
                        .replacingOccurrences(of: "../../Images/", with: "/Images/")
                        .data(using: .utf8)
                    return (name: file.name, content: data)
                }
                .forEach {
                    try context
                        .createOutputFolder(at: "api/posts")
                        .createFile(at: $0.name, contents: $0.content)
                }
        }
    }
}

struct PostJSON: Encodable {
    let title: String
    let readingTime: Int
    let date: Date
    let imagePath: String?
    let contentPath: String
    let color: String?

    init(item: Item<OliverBinns>) {
        title = item.title
        date = item.date
        readingTime = item.readingTime.minutes
        imagePath = item.imagePath?.string
        contentPath = item.path.string
        color = item.metadata.color
    }
}
