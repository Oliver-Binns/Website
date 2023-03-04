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
                SiteHeader(context: context, selectedSelectionID: nil)

                About()

                Divider()

                Wrapper {
                    H3("Posts")
                    PostList(posts: context.sections[.posts].items)
                }

                Divider()

                Wrapper {
                    H3("Times")
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
                SiteHeader(context: context, selectedSelectionID: section.id)
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
                    SiteHeader(context: context, selectedSelectionID: item.sectionID)
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<OliverBinns>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .global,
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<OliverBinns>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1("Browse all tags")
                    List(page.tags.sorted()) { tag in
                        ListItem {
                            Link(tag.string,
                                 url: context.site.path(for: tag).absoluteString
                            )
                        }
                        .class("tag")
                    }
                    .class("all-tags")
                }
                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<OliverBinns>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

                    Link("Browse all tags",
                        url: context.site.tagListPath.absoluteString
                    )
                    .class("browse-all")

                    ItemList(
                        items: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        site: context.site
                    )
                }
                SiteFooter()
            }
        )
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>
    var selectedSelectionID: Site.SectionID?

    var body: Component {
        Header {
            Wrapper {
                Link(url: "/") {
                    Image(url: "/images/oliver-binns.svg", description: "Oliver Binns")
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
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
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
                        Image(url: "/images/github.svg", description: "GitHub Logo")
                            .class("icon")
                        Text(" oliver-binns")
                    }.linkTarget(.blank)
                }
                H2 {
                    Link(url: "https://www.twitter.com/oliver_binns") {
                        Image(url: "/images/twitter.svg", description: "Twitter Logo")
                            .class("icon")
                        Text(" oliver_binns")
                    }.linkTarget(.blank)
                }
                H2 {
                    Link(url: "https://www.linkedin.com/in/obinns/") {
                        Image(url: "/images/in.svg", description: "LinkedIn Logo")
                            .class("icon")
                        Text(" obinns")
                    }.linkTarget(.blank)
                }
            }
        }
    }
}

extension Item<OliverBinns>: Comparable {
    public static func < (lhs: Publish.Item<Site>, rhs: Publish.Item<Site>) -> Bool {
        lhs.date > rhs.date
    }
}
