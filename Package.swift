// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "swift-foundation-difftool",
    dependencies: [
        .Package(url: "https://github.com/ianpartridge/CommandLine", majorVersion: 3)
    ]
)
