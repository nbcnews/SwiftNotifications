// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "SwiftNotifications",
  platforms: [.iOS(.v12), .tvOS(.v12)],
  products: [
    .library(name: "SwiftNotifications", type: .static, targets: ["SwiftNotifications"])
  ],
  targets: [
    .target(name: "SwiftNotifications", path: ".", exclude: ["SwiftNotificationsTests"]),
    .testTarget(
      name: "SwiftNotificationsTests",
      dependencies: ["SwiftNotifications"],
      path: "SwiftNotificationsTests"
    )
  ]
)
