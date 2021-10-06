// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "Dracula",
  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [ .library(name: "Dracula", targets: ["Dracula"]) ],
  targets: [
    .target(name:"Dracula"),
    .testTarget(name: "DraculaTests", dependencies: [ "Dracula" ])
  ]
)
