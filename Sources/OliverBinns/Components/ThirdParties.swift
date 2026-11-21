import Plot
import Publish

extension Node where Context == HTML.DocumentContext {
    /// The page's single `<head>`. This is Publish's `.head(for:on:)` plus the
    /// site's fonts, theme colour, App Store banner and analytics. Adding
    /// extra `.head(...)` nodes instead would output several `<head>` elements,
    /// which is invalid HTML.
    ///
    /// The viewport comes from `.viewport(.accordingToDevice)`. It must not
    /// set `maximum-scale` or `user-scalable`, so pinch-zoom keeps working
    /// (WCAG 1.4.4).
    ///
    /// - parameter includeAnalytics: Load Google Analytics. Only item pages do.
    static func siteHead<T: Website>(for location: Location,
                                     on site: T,
                                     includeAnalytics: Bool = false) -> Node {
        let title = location.title.isEmpty
            ? site.name
            : "\(location.title) | \(site.name)"
        let description = location.description.isEmpty
            ? site.description
            : location.description

        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .stylesheet("/styles.css"),
            .viewport(.accordingToDevice),
            .unwrap(site.favicon, { .favicon($0) }),
            .rssFeedLink(Path.defaultForRSSFeed.absoluteString, title: "Subscribe to \(site.name)"),
            .unwrap(location.imagePath ?? site.imagePath, { .socialImageLink(site.url(for: $0)) }),

            // Instrument Serif (headings)
            .link(.rel(.preconnect), .href("https://fonts.googleapis.com")),
            .link(.rel(.preconnect), .href("https://fonts.gstatic.com"),
                  .attribute(named: "crossorigin", value: "")),
            .link(.rel(.stylesheet),
                  .href("https://fonts.googleapis.com/css2?family=Instrument+Serif&display=swap")),

            .meta(.name("theme-color"), .content("#F5C518")),
            .meta(
                .name("apple-itunes-app"),
                .content("app-id=1535326851, app-clip-bundle-id=uk.co.oliverbinns.oliverbinns.clip")
            ),

            .if(includeAnalytics, .group([
                .script(.async(), .src("https://www.googletagmanager.com/gtag/js?id=G-Y17266J9BZ")),
                .script(.raw("""
            window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());

              gtag('config', 'G-Y17266J9BZ');
            """))
            ]))
        )
    }
}
