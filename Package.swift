// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "mactrans",
    platforms: [.macOS("26.0")],
    targets: [
        .target(name: "TranslateCore"),
        .executableTarget(name: "mactrans", dependencies: ["TranslateCore"]),
        .executableTarget(name: "MacTransService", dependencies: ["TranslateCore"]),
    ]
)
