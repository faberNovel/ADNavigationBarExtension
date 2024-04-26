// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ADNavigationBarExtension",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ADNavigationBarExtension",
            targets: ["ADNavigationBarExtension"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:faberNovel/ADUtils.git", from: "12.1.0"),
    ],
    targets: [
        .target(
            name: "ADNavigationBarExtension",
            dependencies: [
                .product(name: "ADUtils", package: "ADUtils"),
            ],
            path: "NavigationBarExtension/Classes"
        )
    ]
)
