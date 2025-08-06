// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EFI-Swift-GUI",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "EFI-Swift-GUI",
            targets: ["EFI-Swift-GUI"]
        )
    ],
    targets: [
        .executableTarget(
            name: "EFI-Swift-GUI",
            path: "Sources"
        )
    ]
)
