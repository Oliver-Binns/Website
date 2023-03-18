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
        case things
        case times
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let icon: String?
        let color: String?
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://www.oliverbinns.co.uk")!
    var name = "Oliver Binns"
    var description = "Lead Mobile Developer"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try OliverBinns()
    .publish(using: [
        .installPlugin(.splash(withClassPrefix: "")),
        .installPlugin(.youtube()),
        .installPlugin(.links()),

        .addMarkdownFiles(),

        .installPlugin(.readingTime()),
        .generateHTML(withTheme: .oliver),

        .copyResources(at: "Resources/Theme/images", to: "images"),
        .copyResources(at: "Resources/images", to: "images"),

        .generateAPI,
        .generateRSSFeed(including: [.posts]),
    ])
