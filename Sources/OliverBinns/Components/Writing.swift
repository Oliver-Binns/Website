import Foundation
import Plot
import Publish

/// The homepage writing section, matching `redesign/Main.dc.html`'s
/// `#writing` section: the latest few posts as a simple list (title, date
/// and first tag), plus a link to the full posts index.
struct Writing: Component {
    let section: Section<OliverBinns>

    private static let maxPosts = 3

    var body: Component {
        PageSection(id: "writing") {
            H2(section.title).id(PageSection.headingID(for: "writing"))
            List(section.items.sorted { $0.date > $1.date }.prefix(Self.maxPosts)) { post in
                ListItem {
                    Link(post.title, url: post.path.absoluteString)
                        .class("post-link")
                    Span {
                        DateText(date: post.date)
                        if let tag = post.tags.first {
                            Text(" · \(tag.string)")
                        }
                    }.class("post-meta")
                }
            }.class("post-list")
            Paragraph {
                Link(url: section.path.absoluteString) {
                    Text("View all \(section.items.count) posts ")
                    Decorative("→")
                }
            }.class("posts-all")
        }
    }
}
