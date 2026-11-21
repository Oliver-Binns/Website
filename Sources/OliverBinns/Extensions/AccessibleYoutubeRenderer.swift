import YoutubePublishPlugin

/// Renders `> youtube <url>` embeds with a `title` on the iframe, so screen
/// readers can name the frame (WCAG 4.1.2). Also drops the fixed size and
/// the deprecated `frameborder`: `.youtube iframe` in CSS sizes it.
struct AccessibleYoutubeRenderer: YoutubeRenderer {
    func render(youtube: EmbeddedYoutube) throws -> String {
        youtube.html
            .replacingOccurrences(of: "<iframe width=\"\(youtube.width)\" height=\"\(youtube.height)\"",
                                  with: "<iframe title=\"Embedded YouTube video\" loading=\"lazy\"")
            .replacingOccurrences(of: " frameborder=\"0\"", with: "")
    }
}
