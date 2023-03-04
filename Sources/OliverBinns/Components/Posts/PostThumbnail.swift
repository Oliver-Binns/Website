import Foundation
import Plot
import Publish

struct PostThumbnail: Component {
    var post: Item<OliverBinns>

    private var theme: String {
        post.metadata.color == nil ? "light": "dark"
    }

    private var style: String {
        post.metadata.color.flatMap { "background-color:\($0);" } ?? ""
    }

    private let dateFormatter = DateFormatter.monthDayYear

    var body: Component {
        Link(url: post.path.absoluteString) {
            Div {
                ComponentGroup {
                    if let path = post.imagePath {
                        Image(path.absoluteString)
                            .attribute(named: "aria-hidden", value: true.description)
                    }
                    H4(dateFormatter.string(from: post.date))
                    H1(post.title)
                }
            }
            .class("blog-post")
            .class(theme)
            .style(style)
        }
    }
}
