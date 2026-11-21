import Plot

public protocol LinkRenderer {
    func render(link: PrettyLink) -> String
}

public final class DefaultLinkRenderer: LinkRenderer {
    public init() { }
    public func render(link: PrettyLink) -> String {
        PrettyLinkComponent(link: link).render()
    }
}

struct PrettyLinkComponent: Component {
    let link: PrettyLink

    var body: Component {
        Link(url: link.href) {
            Div {
                if let image = link.image {
                    // Decorative: the title and description name the link.
                    Node<HTML.BodyContext>.img(
                        .src(image),
                        Attribute(name: "alt", value: "", ignoreIfValueIsEmpty: false)
                    )
                }
                Div {
                    // Not a heading: these cards sit inside a post's text, so
                    // a heading here would break the post's outline.
                    Span(link.title).class("pretty-link-title")
                    Paragraph(link.description)
                }
            }.class("pretty-link")
        }
        .class("pretty-link-container")
        .linkTarget(.blank)
    }
}
