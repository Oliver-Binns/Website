import Ink
import Publish

public extension Plugin {
    static func links(renderer: LinkRenderer = DefaultLinkRenderer()) -> Self {
        Plugin(name: "link") { context in
            context.markdownParser.addModifier(.linkBlockQuote(using: renderer))
        }
    }
}

public extension Modifier {
    static func linkBlockQuote(using renderer: LinkRenderer) -> Self {
        Modifier(target: .blockquotes) { html, markdown in
            let lines = markdown.components(separatedBy: .newlines)
            guard let href = lines[0].removePrefix("> prettylink "),
                  let title = lines.compactMap({ $0.removePrefix("> title ") }).first,
                  let description = lines.compactMap({ $0.removePrefix("> description ") }).first else {
                return html
            }
            let image = lines.compactMap({ $0.removePrefix("> image ") }).first
            let link = PrettyLink(href: href,
                                  title: title,
                                  description: description,
                                  image: image)
            return renderer.render(link: link)
        }
    }
}

extension String {
    func removePrefix(_ prefix: String) -> String? {
        guard hasPrefix(prefix) else { return nil }
        return String(suffix(from: index(startIndex, offsetBy: prefix.count)))
    }
}
