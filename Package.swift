// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoTrim",
    platforms: [
        // iOS 11 이상을 지원하도록 설정
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "PhotoTrim",
            // dynamic linking을 지원하도록 설정
            type: .dynamic,
            targets: ["PhotoTrim"]),
    ],
    dependencies: [
        // 외부 종속성이 필요한 경우 여기에 추가
    ],
    targets: [
        .target(
            name: "PhotoTrim",
            dependencies: [],
            // 리소스 파일이 필요한 경우를 대비한 설정
            resources: [
                .process("Resources")
            ],
            // Swift 언어 관련 설정 추가
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "PhotoTrimTests",
            dependencies: ["PhotoTrim"]
        ),
    ],
    // 지원하는 Swift 버전 명시
    swiftLanguageVersions: [.v5]
)
