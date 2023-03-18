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
            let encodedData = try JSONEncoder().encode(items)
            try file.append(encodedData)
        })
    }

    private static var outputPosts: Self {
        .copyFiles(at: "Content/posts", to: "api/posts")
    }
}

struct PostJSON: Encodable {
    let title: String
    let readingTime: Int
    let date: Date
    let imagePath: String?
    let contentPath: String

    init(item: Item<OliverBinns>) {
        title = item.title
        date = item.date
        readingTime = item.readingTime.minutes
        imagePath = item.imagePath?.string
        contentPath = item.path.string
    }
}
