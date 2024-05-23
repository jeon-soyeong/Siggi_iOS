import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "Siggi",
                          destinations: .iOS,
                          dependencies: [.project(target: "Common", path: .relativeToRoot("Projects/Common"))])
