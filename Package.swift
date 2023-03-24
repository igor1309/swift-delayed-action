// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-delayed-action",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .delayedAction,
    ],
    dependencies: [
    ],
    targets: [
        .delayedAction,
        .delayedActionTests,
    ]
)

private extension Product {
    
    static let delayedAction = library(
        name: .delayedAction,
        targets: [
            .delayedAction,
        ]
    )
}

private extension Target {
    
    static let delayedAction = target(name: .delayedAction)
    static let delayedActionTests = testTarget(
        name: .delayedActionTests,
        dependencies: [
            .delayedAction,
        ]
    )
}

private extension Target.Dependency {
    
    static let delayedAction = byName(name: .delayedAction)
}

private extension String {
    
    static let delayedAction = "DelayedAction"
    static let delayedActionTests = "DelayedActionTests"
}
