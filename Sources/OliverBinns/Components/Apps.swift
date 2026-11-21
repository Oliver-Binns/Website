import Plot
import Publish

/// The homepage apps section, matching `redesign/Main.dc.html`'s `#apps`
/// section. Each card is driven by a `Content/apps/*.md` item; apps with a
/// `status` (e.g. "Coming soon") get a badge and a highlighted border.
struct Apps: Component {
    let section: Section<OliverBinns>

    var body: Component {
        PageSection(id: "apps") {
            H2(section.title)
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
                    // Placeholder until the app has an icon asset. An app's
                    // brand `color` (if set) replaces the site accent, with
                    // light text so the letter stays readable on dark colours.
                    Div { Text(String(item.title.prefix(1))) }
                        .class("app-icon app-icon-placeholder")
                        .attribute(named: "aria-hidden", value: "true")
                        .attribute(
                            named: "style",
                            value: item.metadata.color.map {
                                "--app-icon-bg: \($0); --app-icon-fg: #fff"
                            }
                        )
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
                let linkText = item.metadata.linkText ?? item.title
                // Short visible text like "Download on the App Store" is
                // ambiguous out of context (e.g. a screen reader's link
                // list), so name the app in the accessible label. It starts
                // with the visible text, so voice control still matches it.
                let accessibleLabel = linkText.contains(item.title)
                    ? nil
                    : "\(linkText): \(item.title)"
                let appLink = Link(linkText, url: link)
                    .class("app-link")
                    .attribute(named: "aria-label", value: accessibleLabel)
                // External links (e.g. the App Store) open in a new tab;
                // `mailto:` links don't need to.
                if link.hasPrefix("http") {
                    appLink.linkTarget(.blank)
                } else {
                    appLink
                }
            }
        }
        .class(item.metadata.status == nil ? "app-card" : "app-card app-card-featured")
    }
}
