import Foundation
import Plot
import Publish

extension Theme where Site == OliverBinns {
    static var oliver: Self {
        Theme(htmlFactory: OliverHTMLFactory(),
              resourcePaths: [
                "Resources/Theme/styles.css"
              ])
    }
}

private struct OliverHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<OliverBinns>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .global,
            .body {
                SiteHeader()

                Hero()

                Highlights()

                Apps(section: context.sections[.apps])

                Speaking(section: context.sections[.speaking])

                Experience(section: context.sections[.experience])

                Writing(section: context.sections[.posts])

                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<OliverBinns>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .global,
            .body {
                SiteHeader()
                Wrapper {
                    H1(section.title)
                    if !section.description.isEmpty {
                        Paragraph(section.description).class("section-intro")
                    }
                    ItemList(items: section.items.sorted { $0.date > $1.date },
                             showsDates: section.id == .posts)
                }.class("list-page")
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<OliverBinns>,
                      context: PublishingContext<OliverBinns>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .global,
            .body(
                .class("item-page"),
                .components {
                    SiteHeader()
                    Wrapper {
                        Article {
                            Div {
                                H1(item.title)
                                // Other sections' dates are only used for
                                // ordering, so only posts show a byline.
                                if item.sectionID == .posts {
                                    Paragraph(item.byline).class("post-byline")
                                }
                                item.content.body
                            }
                            .class("content")
                            .class("post-content")
                        }
                    }.class("post-page")
                    SiteFooter()
                }
            ),
            .scripts
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<OliverBinns>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .global,
            .body {
                SiteHeader()
                Wrapper(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<OliverBinns>) throws -> HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<OliverBinns>) throws -> HTML? {
        nil
    }
}

private struct SiteHeader: Component {
    var body: Component {
        Header {
            Wrapper {
                Link("Oliver Binns", url: "/").class("site-title")
                Div {
                    Link("Highlights", url: "#highlights")
                    Link("Apps", url: "#apps")
                    Link("Speaking", url: "#speaking")
                    Link("Experience", url: "#experience")
                    Link("Writing", url: "#writing")
                }.class("nav-links")
                Link("Get in touch", url: "mailto:mail@oliverbinns.co.uk")
                    .class("btn btn-dark")
            }.class("header-content")
        }
    }
}

/// A full list of a section's items (e.g. every post on `/posts/`), in the
/// same style as the homepage Writing list, with each item's description.
private struct ItemList: Component {
    var items: [Item<OliverBinns>]
    /// Only posts have meaningful dates; other sections' dates just set order.
    var showsDates: Bool

    var body: Component {
        List(items) { item in
            ListItem {
                Div {
                    Link(item.title, url: item.path.absoluteString)
                        .class("post-link")
                    if !item.description.isEmpty {
                        Paragraph(item.description).class("post-description")
                    }
                }
                if showsDates {
                    Span(item.listMeta).class("post-meta")
                }
            }
        }
        .class("post-list")
    }
}

private extension Item where Site == OliverBinns {
    /// e.g. "24 May 2025 · Terraform, Google Play"
    var listMeta: String {
        let tagList = tags.map(\.string).joined(separator: ", ")
        return [DateFormatter.dayMonthYear.string(from: date), tagList]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }

    /// e.g. "24 May 2025 · 12 min read"
    var byline: String {
        "\(DateFormatter.dayMonthYear.string(from: date)) · \(readingTime.minutes) min read"
    }
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Wrapper {
                Div {
                    H2("Let's talk mobile.")
                    Link("mail@oliverbinns.co.uk", url: "mailto:mail@oliverbinns.co.uk")
                        .class("footer-email")
                }
                Div {
                    Link(url: "https://www.github.com/oliver-binns") {
                        Image(url: "/Images/github.svg", description: "GitHub Logo")
                            .class("icon")
                        Text("oliver-binns")
                    }.linkTarget(.blank)
                    Link(url: "https://bsky.app/profile/oliverbinns.co.uk") {
                        Image(url: "/Images/bluesky.svg", description: "Bluesky Logo")
                            .class("icon")
                        Text("oliverbinns.co.uk")
                    }.linkTarget(.blank)
                    Link(url: "https://www.linkedin.com/in/obinns/") {
                        Image(url: "/Images/in.svg", description: "LinkedIn Logo")
                            .class("icon")
                        Text("obinns")
                    }.linkTarget(.blank)
                }.class("footer-links")
            }.class("footer-content")
        }
    }
}

extension Item<OliverBinns>: @retroactive Comparable {
    public static func < (lhs: Publish.Item<Site>, rhs: Publish.Item<Site>) -> Bool {
        lhs.date > rhs.date
    }
}
