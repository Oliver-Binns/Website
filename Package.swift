// swift-tools-version:5.9

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
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),

        .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin",
                 from: "0.3.0"),

        .package(url: "https://github.com/johnsundell/splashpublishplugin",
                 from: "0.2.0"),

        .package(url: "https://github.com/tanabe1478/YoutubePublishPlugin.git",
                 from: "1.0.1")
    ],
    targets: [
        .target(
            name: "LinkPlugin",
            dependencies: [.product(name: "Publish", package: "publish")]
        ),

        .executableTarget(
            name: "OliverBinns",
            dependencies: [
                .product(name: "Publish", package: "publish"),
                .product(name: "SplashPublishPlugin", package: "splashpublishplugin"),
                .product(name: "ReadingTimePublishPlugin", package: "ReadingTimePublishPlugin"),
                .product(name: "YoutubePublishPlugin", package: "YoutubePublishPlugin"),
                "LinkPlugin"
            ]
        )
    ]
)
