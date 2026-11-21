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
            H2(section.title).id(PageSection.headingID(for: "speaking"))
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
                ExternalLink(url: Self.allTalksURL) {
                    Text("All talks, slides and resources on GitHub ")
                    Decorative("→")
                }
            }.class("talks-all")
        }
    }
}

private struct TalkCard: Component {
    let item: Item<OliverBinns>

    /// A talk is upcoming until its (latest) event date has passed. The
    /// badge updates whenever the site is rebuilt.
    private var isUpcoming: Bool { item.date > Date() }

    /// The talk's Markdown body. Every card has links like "Watch the talk",
    /// so each link also gets the talk's name as hidden text, e.g. "Watch the
    /// talk: Building the Foundations", to make it unique (WCAG 2.4.9).
    private var bodyHTML: String {
        let title = item.title
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
        return item.body.html.replacingOccurrences(
            of: newTabWarningHTML,
            with: "<span class=\"visually-hidden\">: \(title) (opens in new tab)</span>"
        )
    }

    /// The talk's meta line reads e.g. "Leeds Mobile · Jun 2025": the venue
    /// from `event` metadata plus the month and year of the (latest) date.
    private static let monthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()

    var body: Component {
        Article {
            if isUpcoming {
                Span("Upcoming").class("talk-badge")
            }
            H3(item.title)
            Paragraph {
                if let event = item.metadata.event {
                    Text("\(event) · ")
                }
                DateText(date: item.date, formatter: Self.monthYear)
            }.class("talk-meta")
            Div { Node<HTML.BodyContext>.raw(bodyHTML) }.class("talk-body")
        }
        .class(isUpcoming ? "talk-card talk-card-featured" : "talk-card")
    }
}
