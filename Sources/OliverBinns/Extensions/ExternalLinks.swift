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

    /// Code blocks scroll horizontally, so make each one focusable and give
    /// it a name, so keyboard users can scroll it (WCAG 2.1.1).
    static var accessibleCodeBlocks: Self {
        Plugin(name: "Accessible code blocks") { context in
            context.markdownParser.addModifier(Modifier(target: .codeBlocks) { html, _ in
                guard html.hasPrefix("<pre>") else { return html }
                return "<pre tabindex=\"0\" role=\"region\" aria-label=\"Code sample\">"
                    + html.dropFirst("<pre>".count)
            })
        }
    }
}
