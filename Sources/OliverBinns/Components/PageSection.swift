import Plot

/// A full-width homepage `<section>` with an anchor `id`, wrapping its
/// content in the shared max-width `Wrapper`. The section is named by its
/// heading, which must have the id `"<id>-heading"` (see `headingID(for:)`),
/// so it shows up as a labelled region for screen-reader users. Alternating backgrounds
/// (`#fffdf7` / `#f6f1e1`, matching `redesign/Main.dc.html`) are applied via
/// CSS `nth-of-type`, not a per-instance parameter.
struct PageSection: Component {
    private let id: String
    private let content: ComponentGroup

    init(id: String, @ComponentBuilder content: () -> ComponentGroup) {
        self.id = id
        self.content = content()
    }

    /// The id the section's heading needs, so the section can reference it.
    static func headingID(for sectionID: String) -> String {
        "\(sectionID)-heading"
    }

    var body: Component {
        SectionElement {
            Wrapper { content }
        }
        .class("section")
        .id(id)
        .attribute(named: "aria-labelledby", value: Self.headingID(for: id))
    }
}
