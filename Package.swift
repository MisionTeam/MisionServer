// Generated automatically by Perfect Assistant Application
// Date: 2017-03-05 18:08:20 +0000
import PackageDescription
let package = Package(
    name: "MisionServer",
    
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MongoDB.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", majorVersion: 2),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2),
        .Package(url: "https://github.com/SwiftORM/MySQL-StORM.git", majorVersion: 1),
    ]
)
