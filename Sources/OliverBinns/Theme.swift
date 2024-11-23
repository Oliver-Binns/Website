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

                About()

                Divider()

                Wrapper {
                    H3("Posts")
                    PostList(posts: context.sections[.posts].items)
                }

                Divider()

                Wrapper {
                    H3("Positions")
                    Timeline(items: context.sections[.times].items)
                }

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
                    ItemList(items: section.items, site: context.site)
                }
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
                                Text("Approx: \(item.readingTime.minutes) minutes reading time")
                                    .italic()
                                item.content.body
                            }
                            .class("content")
                            .class("post-content")
                        }
                    }.style("max-width:800px")
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
                Link(url: "/") {
                    Image(url: "/Images/oliver-binns.svg", description: "Oliver Binns")
                    H2("Lead Mobile Developer")
                }
            }
        }
    }
}

private struct PostList: Component {
    let posts: [Item<OliverBinns>]

    var body: Component {
        Div {
            ComponentGroup(members: posts.sorted().map(PostThumbnail.init))
        }.class("blog")
    }
}



private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Wrapper {
                H2 {
                    Link("mail@oliverbinns.co.uk", url: "mailto:mail@oliverbinns.co.uk")
                }
                H2 {
                    Link(url: "https://www.github.com/oliver-binns") {
                        Image(url: "/Images/github.svg", description: "GitHub Logo")
                            .class("icon")
                        Text(" oliver-binns")
                    }.linkTarget(.blank)
                }
                H2 {
                    Link(url: "https://bsky.app/profile/oliverbinns.co.uk") {
                        Image(url: "/Images/bluesky.svg", description: "Bluesky Logo")
                            .class("icon")
                        Text(" oliverbinns.co.uk")
                    }.linkTarget(.blank)
                }
                H2 {
                    Link(url: "https://www.linkedin.com/in/obinns/") {
                        Image(url: "/Images/in.svg", description: "LinkedIn Logo")
                            .class("icon")
                        Text(" obinns")
                    }.linkTarget(.blank)
                }
            }
        }
    }
}

extension Item<OliverBinns>: @retroactive Comparable {
    public static func < (lhs: Publish.Item<Site>, rhs: Publish.Item<Site>) -> Bool {
        lhs.date > rhs.date
    }
}
