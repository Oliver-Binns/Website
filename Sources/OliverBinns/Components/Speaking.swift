import Foundation
import Plot
import Publish

/// The homepage speaking section, matching `redesign/Main.dc.html`'s
/// `#speaking` section. Each card is one talk from `Content/speaking`; a
/// talk given at several events lists them in its Markdown body. Only the
/// most recent talks are shown, with a link to the full talks repository.
struct Speaking: Component {
    let section: Section<OliverBinns>

    private static let maxTalks = 6
    private static let allTalksURL = "https://github.com/obinns-dd/talks"

    var body: Component {
        PageSection(id: "speaking") {
            H2(section.title)
            if !section.description.isEmpty {
                Paragraph(section.description).class("section-intro")
            }
            Div {
                ComponentGroup(members: section.items
                    .sorted { $0.date > $1.date }
                    .prefix(Self.maxTalks)
                    .map(TalkCard.init))
            }.class("talks-grid")
            Paragraph {
                Link("All talks, slides and resources on GitHub →",
                     url: Self.allTalksURL)
                    .linkTarget(.blank)
            }.class("talks-all")
        }
    }
}

private struct TalkCard: Component {
    let item: Item<OliverBinns>

    /// A talk is upcoming until its (latest) event date has passed. The
    /// badge updates whenever the site is rebuilt.
    private var isUpcoming: Bool { item.date > Date() }

    var body: Component {
        Article {
            if isUpcoming {
                Span("Upcoming").class("talk-badge")
            }
            H3(item.title)
            if let event = item.metadata.event {
                Paragraph(event).class("talk-meta")
            }
            Div { item.body.openingExternalLinksInNewTab }.class("talk-body")
        }
        .class(isUpcoming ? "talk-card talk-card-featured" : "talk-card")
    }
}

private extension Content.Body {
    /// Markdown has no syntax for link targets, so add `target="_blank"` to
    /// external (http/https) links in rendered talk bodies, matching the
    /// `.linkTarget(.blank)` used for external links elsewhere on the site.
    var openingExternalLinksInNewTab: Content.Body {
        Content.Body(html: html.replacingOccurrences(
            of: "<a href=\"http",
            with: "<a target=\"_blank\" href=\"http"
        ))
    }
}
