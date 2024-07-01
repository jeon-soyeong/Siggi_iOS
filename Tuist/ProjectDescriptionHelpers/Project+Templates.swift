import ProjectDescription

extension Project {
    public static func featureApp(name: String, product: Product, dependencies: [TargetDependency] = []) -> Project {
    return Project(
        name: name,
        targets: [
            .target(
                name: name,
                destinations: .iOS,
                product: product,
                bundleId: "com.\(name)",
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: ["Resources/**",],
                dependencies: dependencies
            ),
            .target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.\(name)Tests",
                infoPlist: .default,
                sources: ["Tests/**"],
                dependencies: [.target(name: name)]
            )
        ]
    )
  }
}
