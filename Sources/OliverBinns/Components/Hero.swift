import Plot

/// The homepage hero, replacing the old `About` biography block. Matches
/// `redesign/Main.dc.html`'s `#top` section: eyebrow + headline + summary,
/// CTA buttons, social links, and profile photo.
struct Hero: Component {
    var body: Component {
        PageSection(id: "top") {
            Div {
                Div {
                    Paragraph("Associate Director, Deloitte Digital")
                        .class("eyebrow")

                    H1("Lead mobile developer building apps used by millions.")
                        .id(PageSection.headingID(for: "top"))

                    Paragraph("""
                    I lead teams building high-profile mobile apps, and I'm happiest deep in native iOS. \
                    When I learn something useful, I share it, whether that's a conference talk, \
                    a blog post or open source code.
                    """).class("hero-description")

                    Div {
                        Link("See my talks", url: "#speaking")
                            .class("btn btn-primary")
                        ExternalLink("GitHub", url: "https://www.github.com/oliver-binns")
                            .class("btn btn-outline")
                    }.class("hero-ctas")

                    Div {
                        ComponentGroup(members: SocialLink.all)
                    }.class("hero-socials")
                }.class("hero-text")

                Div {
                    Image(url: "/Images/profile-right.jpg",
                          description: "A photo of Oliver")
                }.class("hero-photo")
            }.class("hero")
        }
    }
}
