import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: "Common",
                                destinations: .iOS,
                                additionalTargets: [],
                                dependencies: [])
