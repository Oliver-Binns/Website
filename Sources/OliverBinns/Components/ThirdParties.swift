import Plot

extension Node where Context == HTML.DocumentContext {
    private static var quicksandFont: Node<Context> {
        .head(
            .link(.rel(.preconnect), .href("https://fonts.googleapis.com")),
            .link(.rel(.preconnect), .href("https://fonts.gstatic.com"), .attribute(named: "crossorigin", value: "")),
            .link(.rel(.stylesheet), .href("https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"))
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
                .src("https://kit.fontawesome.com/99e4242f25.js"),
                .attribute(named: "crossorigin", value: "anonymous")
            )
        )
    }


    static var global: Node<Context> {
        .group([quicksandFont, theme, fontAwesome])
    }
}
