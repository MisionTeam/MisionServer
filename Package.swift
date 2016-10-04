import PackageDescription
 
let package = Package(
    name: "MisionServer",
    dependencies: [
        .Package(
        url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", 
        majorVersion: 2, minor: 0
        )
    ]
)
