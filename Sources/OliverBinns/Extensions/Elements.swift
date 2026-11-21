import Foundation
import Plot

/// Element components that Plot doesn't provide out of the box, so that pages
/// can use proper landmarks (`<main>`, `<section>`) and machine-readable
/// dates (`<time>`).
enum SiteElements {
    enum Main: ElementDefinition {
        static var wrapper = Node<HTML.BodyContext>.main
    }

    enum Section: ElementDefinition {
        static var wrapper = Node<HTML.BodyContext>.section
    }

    enum Time: ElementDefinition {
        static var wrapper = Node<HTML.BodyContext>.time
    }
}

typealias Main = ElementComponent<SiteElements.Main>
typealias SectionElement = ElementComponent<SiteElements.Section>
typealias TimeElement = ElementComponent<SiteElements.Time>

extension Node where Context == HTML.BodyContext {
    static func time(_ nodes: Node<HTML.BodyContext>...) -> Node {
        .element(named: "time", nodes: nodes)
    }
}

/// A `<time>` element for a date, e.g. `<time datetime="2025-05-24">24 May 2025</time>`.
struct DateText: Component {
    let date: Date
    var formatter: DateFormatter = .dayMonthYear

    private static let iso: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var body: Component {
        TimeElement { Text(formatter.string(from: date)) }
            .attribute(named: "datetime", value: Self.iso.string(from: date))
    }
}

/// Text that only screen readers announce (see `.visually-hidden` in CSS).
struct VisuallyHidden: Component {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: Component {
        Span(text).class("visually-hidden")
    }
}

/// Decorative text, such as a trailing "→", that screen readers skip.
struct Decorative: Component {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: Component {
        Span(text).attribute(named: "aria-hidden", value: "true")
    }
}
