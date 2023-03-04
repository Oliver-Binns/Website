// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OliverBinns",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "OliverBinns",
            targets: ["OliverBinns"]
        )
    ],
    dependencies: [
        .package(name: "Publish",
                 url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),

        .package(name: "ReadingTimePublishPlugin",
                 url: "https://github.com/alexito4/ReadingTimePublishPlugin",
                 from: "0.2.0"),

        .package(name: "SplashPublishPlugin",
                 url: "https://github.com/johnsundell/splashpublishplugin",
                 from: "0.2.0")
    ],
    targets: [
        .executableTarget(name: "OliverBinns", dependencies: [
            "Publish",
            "SplashPublishPlugin",
            "ReadingTimePublishPlugin"
        ])
    ]
)
