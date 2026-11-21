import Plot

extension Node where Context == HTML.DocumentContext {
    private static var displayFont: Node<Context> {
        .head(
            .link(.rel(.preconnect), .href("https://fonts.googleapis.com")),
            .link(.rel(.preconnect), .href("https://fonts.gstatic.com"), .attribute(named: "crossorigin", value: "")),
            .link(.rel(.stylesheet), .href("https://fonts.googleapis.com/css2?family=Instrument+Serif&display=swap"))
        )
    }

    private static var theme: Node<Context> {
        .head(
            .meta(.name("viewport"), .content("width=device-width, initial-scale=1, maximum-scale=1")),
            .meta(.name("theme-color"), .content("#F9C300"))
        )
    }

    private static var fontAwesome: Node<Context> {
        .head(
            .script(
                .async(),
                .src("https://kit.fontawesome.com/99e4242f25.js"),
                .attribute(named: "crossorigin", value: "anonymous")
            )
        )
    }

    private static var googleAnalytics: Node<Context> {
        .head(
            .script(
                .async(),
                .src("https://www.googletagmanager.com/gtag/js?id=G-Y17266J9BZ")
            ),
            .script(.raw("""
            window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());

              gtag('config', 'G-Y17266J9BZ');
            """))
        )
    }

    private static var appStore: Node<Context> {
        .head(.meta(
            .name("apple-itunes-app"),
            .content("app-id=1535326851, app-clip-bundle-id=uk.co.oliverbinns.oliverbinns.clip")
        ))
    }

    private static var juxtapose: Node<Context> {
        .head(
            .script(.src("https://cdn.knightlab.com/libs/juxtapose/latest/js/juxtapose.min.js")),
            .link(.rel(.stylesheet), .href("https://cdn.knightlab.com/libs/juxtapose/latest/css/juxtapose.css"))
        )
    }

    static var global: Node<Context> {
        .group([displayFont, fontAwesome, theme, appStore])
    }

    static var scripts: Node<Context> {
        .group([googleAnalytics, juxtapose])
    }
}
