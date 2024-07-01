import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.featureApp(name: "Siggi",
                                 product: .app,
                                 dependencies: [
                                        .project(target: "Common", path: "../Common"),
//                                        .external(name: "Alamofire")
                                 ])
