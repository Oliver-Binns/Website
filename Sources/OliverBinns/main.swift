import Foundation
import LinkPlugin
import Plot
import Publish
import ReadingTimePublishPlugin
import SplashPublishPlugin
import YoutubePublishPlugin

// This type acts as the configuration for your website.
struct OliverBinns: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case apps
        case experience
        case speaking
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let color: String?

        // Apps-only metadata (see `Content/apps`).
        let appIcon: String?
        let platform: String?
        let released: String?
        let status: String?
        let link: String?
        let linkText: String?

        // Speaking-only metadata (see `Content/speaking`): the venue, shown
        // alongside the month and year from the item's `date`.
        let event: String?

        // Experience-only metadata (see `Content/experience`): the role's date
        // range, and whether it gets a card on the homepage.
        let period: String?
        let featured: Bool?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://www.oliverbinns.co.uk")!
    var name = "Oliver Binns"
    var description = "Lead Mobile Developer"
    // British English, so screen readers use the right pronunciation.
    var language: Language { .ukEnglish }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try OliverBinns()
    .publish(using: [
        .installPlugin(.splash(withClassPrefix: "")),
        .installPlugin(.youtube()),
        .installPlugin(.links()),
        .installPlugin(.externalLinksInNewTab),

        .addMarkdownFiles(),

        .installPlugin(.readingTime()),
        .generateHTML(withTheme: .oliver),

        .copyResources(at: "Resources/Theme/Images", to: "Images"),
        .copyResources(at: "Images", to: "Images"),
        .copyFile(at: "Resources/404.php"),
        .copyFile(at: "Resources/.htaccess"),

        .generateAPI,
        .generateRSSFeed(including: [.posts]),
    ])
