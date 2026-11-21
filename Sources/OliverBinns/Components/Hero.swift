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

                    Paragraph("""
                    I lead teams building high-profile mobile apps, and I'm happiest deep in native iOS. \
                    When I learn something useful, I share it, whether that's a conference talk, \
                    a blog post or open source code.
                    """).class("hero-description")

                    Div {
                        Link("See my talks", url: "#speaking")
                            .class("btn btn-primary")
                        Link("GitHub", url: "https://www.github.com/oliver-binns")
                            .class("btn btn-outline")
                            .linkTarget(.blank)
                    }.class("hero-ctas")

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
