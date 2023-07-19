// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SliderController",
    platforms: [
        .iOS("11.0"),
    ],
    products: [
        .library(name: "SliderController", targets: ["SliderController"]),
    ],
    targets: [
        .target(name: "SliderController", path: "Source"),
    ]
)
