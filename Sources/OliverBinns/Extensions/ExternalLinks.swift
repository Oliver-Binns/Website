import Ink
import Publish

extension Plugin {
    /// Markdown has no syntax for link targets, so add `target="_blank"` to
    /// every external (http/https) Markdown link across the site, matching
    /// the `ExternalLink` component used in the theme. Each one also gets
    /// `rel="noopener"` and a screen-reader "(opens in new tab)" warning
    /// (WCAG 3.2.5).
    static var externalLinksInNewTab: Self {
        Plugin(name: "External links in new tab") { context in
            context.markdownParser.addModifier(Modifier(target: .links) { html, _ in
                let externalLink = "<a href=\"http"
                guard html.hasPrefix(externalLink), html.hasSuffix("</a>") else { return html }
                let opened = "<a target=\"_blank\" rel=\"noopener\" href=\"http"
                    + html.dropFirst(externalLink.count).dropLast("</a>".count)
                return opened + newTabWarningHTML + "</a>"
            })
        }
    }
}
