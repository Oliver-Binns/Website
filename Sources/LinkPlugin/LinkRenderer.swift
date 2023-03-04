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
                    Image(image)
                        .attribute(named: "aria-hidden", value: "true")
                }
                Div {
                    H1(link.title)
                    Paragraph(link.description)
                }
            }.class("pretty-link")
        }
        .linkTarget(.blank)
    }
}
