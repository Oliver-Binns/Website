import Plot

/// A single award/highlight card shown in the `Highlights` section.
private struct Highlight {
    let title: String
    let description: String
}

/// The homepage highlights/awards strip, matching `redesign/Main.dc.html`'s
/// `#highlights` section. Data is hardcoded since it rarely changes and
/// isn't worth a dedicated content type.
struct Highlights: Component {
    private static let items: [Highlight] = [
        Highlight(
            title: "BCS 2024",
            description: "Shortlisted, Engineer of the Year, UK IT Industry Awards"
        ),
        Highlight(
            title: "BIMA10",
            description: "Winner, COVID-19 National Testing Programme mobile apps"
        ),
        Highlight(
            title: "WWDC",
            description: "Apple scholar in 2015 and 2016"
        ),
        Highlight(
            title: "Cisco 2012",
            description: "Human Networking Award for best use of IT, Young Enterprise national final"
        )
    ]

    var body: Component {
        PageSection(id: "highlights") {
            // Every section needs a heading (WCAG 2.4.10); this one is only
            // for screen readers, as the cards speak for themselves visually.
            H2("Highlights")
                .id(PageSection.headingID(for: "highlights"))
                .class("visually-hidden")
            Div {
                ComponentGroup(members: Self.items.map { item in
                    Div {
                        H3(item.title).class("highlight-title")
                        Paragraph(item.description).class("highlight-description")
                    }.class("highlight-card")
                })
            }.class("highlights-grid")
        }
    }
}
