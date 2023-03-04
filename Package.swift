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
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .executableTarget(name: "OliverBinns", dependencies: ["Publish"])
    ]
)