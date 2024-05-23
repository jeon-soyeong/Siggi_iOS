import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> Project {
        let targets = makeAppTarget(name: name,
                                   destinations: destinations,
                                   dependencies: dependencies)
        return Project(name: name,
                       organizationName: "\(name)",
                       targets: targets)
    }

    public static func framework(name: String, destinations: Destinations, additionalTargets: [String], dependencies: [TargetDependency]) -> Project {
        var targets = makeFrameworkTarget(name: name,
                                           destinations: destinations,
                                           dependencies: dependencies)
        targets += additionalTargets.flatMap({ makeFrameworkTarget(name: $0, destinations: destinations, dependencies: dependencies) })
        return Project(name: name,
                       organizationName: "\(name)",
                       targets: targets)
    }
    
    /// Helper function to create the application target and the unit test target.
    private static func makeAppTarget(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UILaunchStoryboardName": "LaunchScreen"
            ]

        let mainTarget = Target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "com.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.\(name)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
    
    // MARK: - Private
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTarget(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
        let sources = Target(name: name,
                destinations: destinations,
                product: .framework,
                bundleId: "com.\(name)",
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: [],
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "com.\(name)Tests",
                infoPlist: .default,
                sources: ["Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }
}
