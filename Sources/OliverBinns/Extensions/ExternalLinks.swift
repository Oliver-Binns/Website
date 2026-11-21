import Ink
import Publish

extension Plugin {
    /// Markdown has no syntax for link targets, so add `target="_blank"` to
    /// every external (http/https) Markdown link across the site, matching
    /// the `.linkTarget(.blank)` used for external links in the theme.
    static var externalLinksInNewTab: Self {
        Plugin(name: "External links in new tab") { context in
            context.markdownParser.addModifier(Modifier(target: .links) { html, _ in
                let externalLink = "<a href=\"http"
                guard html.hasPrefix(externalLink) else { return html }
                return "<a target=\"_blank\" href=\"http" + html.dropFirst(externalLink.count)
            })
        }
    }
}
