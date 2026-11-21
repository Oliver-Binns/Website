import Plot
import Publish

/// The homepage apps section, matching `redesign/Main.dc.html`'s `#apps`
/// section. Each card is driven by a `Content/apps/*.md` item; apps with a
/// `status` (e.g. "Coming soon") get a badge and a highlighted border.
struct Apps: Component {
    let section: Section<OliverBinns>

    var body: Component {
        PageSection(id: "apps") {
            H2(section.title).id(PageSection.headingID(for: "apps"))
            if !section.description.isEmpty {
                Paragraph(section.description).class("section-intro")
            }
            Div {
                ComponentGroup(members: section.items
                    .sorted { $0.date > $1.date }
                    .map(AppCard.init))
            }.class("apps-grid")
        }
    }
}

private struct AppCard: Component {
    let item: Item<OliverBinns>

    private var subtitle: String {
        [item.metadata.platform, item.metadata.released]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    var body: Component {
        Article {
            if let status = item.metadata.status {
                Span(status).class("app-badge")
            }
            Div {
                if let appIcon = item.metadata.appIcon {
                    // Decorative: the app name is right next to it, so `alt=""`.
                    Node<HTML.BodyContext>.img(
                        .src(appIcon),
                        Attribute(name: "alt", value: "", ignoreIfValueIsEmpty: false),
                        .class("app-icon"),
                        .attribute(named: "width", value: "64"),
                        .attribute(named: "height", value: "64"),
                        .attribute(named: "loading", value: "lazy")
                    )
                } else {
                    // Placeholder until the app has an icon asset.
                    Div { Text(String(item.title.prefix(1))) }
                        .class("app-icon app-icon-placeholder")
                        .attribute(named: "aria-hidden", value: "true")
                }
                Div {
                    H3(item.title)
                    if !subtitle.isEmpty {
                        Paragraph(subtitle).class("app-meta")
                    }
                }
            }.class("app-header")
            Paragraph(item.description)
            if let link = item.metadata.link {
                let text = item.metadata.linkText ?? item.title
                // External links (e.g. the App Store) open in a new tab;
                // `mailto:` links don't need to.
                if link.hasPrefix("http") {
                    ExternalLink(text, url: link).class("app-link")
                } else {
                    Link(text, url: link).class("app-link")
                }
            }
        }
        .class(item.metadata.status == nil ? "app-card" : "app-card app-card-featured")
    }
}
