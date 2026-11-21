import Plot
import Publish

/// The homepage experience section, matching `redesign/Main.dc.html`'s
/// `#experience` section. Roles marked `featured: true` in
/// `Content/experience` are shown newest first; everything else is
/// summarised by the hand-written text in `Content/experience/index.md`,
/// inside a collapsible "Earlier career and education" disclosure.
struct Experience: Component {
    let section: Section<OliverBinns>

    private var featuredRoles: [Item<OliverBinns>] {
        section.items
            .filter { $0.metadata.featured == true }
            .sorted { $0.date > $1.date }
    }

    var body: Component {
        PageSection(id: "experience") {
            H2(section.title)
            Div {
                ComponentGroup(members: featuredRoles.map(RoleSummary.init))
            }.class("experience-grid")
            if !section.body.isEmpty {
                Node<HTML.BodyContext>.details(
                    .class("experience-earlier"),
                    .summary("Earlier career and education"),
                    .div(.class("experience-earlier-body"), .raw(section.body.html))
                )
            }
        }
    }
}

private struct RoleSummary: Component {
    let item: Item<OliverBinns>

    var body: Component {
        Div {
            if let period = item.metadata.period {
                Paragraph(period).class("role-period")
            }
            H3(item.title)
            Paragraph(item.description)
        }.class("role")
    }
}
