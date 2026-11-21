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
            H2(section.title)
            List(section.items.sorted { $0.date > $1.date }.prefix(Self.maxPosts)) { post in
                ListItem {
                    Link(post.title, url: post.path.absoluteString)
                        .class("post-link")
                    Span(Self.meta(for: post)).class("post-meta")
                }
            }.class("post-list")
            Paragraph {
                Link("View all \(section.items.count) posts →",
                     url: section.path.absoluteString)
            }.class("posts-all")
        }
    }

    /// e.g. "24 May 2025 · Terraform"
    private static func meta(for post: Item<OliverBinns>) -> String {
        [dayMonthYear.string(from: post.date), post.tags.first?.string]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    private static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
}
