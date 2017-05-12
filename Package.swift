// Generated automatically by Perfect Assistant Application
// Date: 2017-03-05 18:08:20 +0000
import PackageDescription
let package = Package(
    name: "MisionServer",
    targets: [
        Target(
            name: "MSDataModel",
            dependencies: []
        ),
        Target(
            name: "MSRoutes",
            dependencies: [
                .Target(name: "MSDataModel")
            ]
        ),
        Target(
            name: "MisionServer",
            dependencies: [
                .Target(name: "MSDataModel"),
                .Target(name: "MSRoutes")
            ]
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MongoDB.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2),
        .Package(url: "https://github.com/SwiftORM/MongoDB-StORM.git", majorVersion: 1),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Session.git", majorVersion: 1, minor: 1)
    ]
)
