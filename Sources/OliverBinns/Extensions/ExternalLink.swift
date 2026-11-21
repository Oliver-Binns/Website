import Plot

/// The screen-reader warning appended to every link that opens a new tab
/// (WCAG 3.2.5 Change on Request). Sighted users get a "↗" icon from CSS
/// (`a[target="_blank"]::after`).
let newTabWarningHTML = "<span class=\"visually-hidden\"> (opens in new tab)</span>"

/// A link that opens in a new tab and warns users that it will.
struct ExternalLink: Component {
    let url: String
    let content: ComponentGroup

    init(url: String, @ComponentBuilder content: () -> ComponentGroup) {
        self.url = url
        self.content = content()
    }

    init(_ title: String, url: String) {
        self.init(url: url) { Text(title) }
    }

    var body: Component {
        Link(url: url) {
            content
            VisuallyHidden(" (opens in new tab)")
        }
        .linkTarget(.blank)
        .attribute(named: "rel", value: "noopener")
    }
}

/// A link to one of the site's social profiles, with a decorative icon.
/// The visible text (e.g. "GitHub: oliver-binns") is the accessible name.
struct SocialLink: Component {
    let service: String
    let handle: String
    let url: String
    let icon: String

    static let all: [SocialLink] = [
        SocialLink(service: "GitHub", handle: "oliver-binns",
                   url: "https://www.github.com/oliver-binns", icon: "/Images/github.svg"),
        SocialLink(service: "Bluesky", handle: "oliverbinns.co.uk",
                   url: "https://bsky.app/profile/oliverbinns.co.uk", icon: "/Images/bluesky.svg"),
        SocialLink(service: "LinkedIn", handle: "obinns",
                   url: "https://www.linkedin.com/in/obinns/", icon: "/Images/in.svg")
    ]

    var body: Component {
        ExternalLink(url: url) {
            Node<HTML.BodyContext>.img(
                .src(icon),
                Attribute(name: "alt", value: "", ignoreIfValueIsEmpty: false),
                .class("icon")
            )
            VisuallyHidden("\(service): ")
            Text(handle)
        }
    }
}
