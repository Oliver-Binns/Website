import Plot

/// A full-width homepage section with an optional anchor `id`, wrapping its
/// content in the shared max-width `Wrapper`. Alternating backgrounds
/// (`#fffdf7` / `#f6f1e1`, matching `redesign/Main.dc.html`) are applied via
/// CSS `nth-of-type`, not a per-instance parameter.
struct PageSection: Component {
    private let id: String?
    private let content: ComponentGroup

    init(id: String? = nil, @ComponentBuilder content: () -> ComponentGroup) {
        self.id = id
        self.content = content()
    }

    var body: Component {
        let section = Div {
            Wrapper { content }
        }
        .class("section")

        if let id {
            return section.id(id)
        }
        return section
    }
}
