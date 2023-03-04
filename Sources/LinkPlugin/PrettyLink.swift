import Foundation

public struct PrettyLink: Hashable, Codable {
    public let href: String
    public let title: String
    public let description: String
    public let image: String?
}
