// swift-tools-version:5.5
import PackageDescription

// これが、Xcodeでプレビューとビルドを確実に行うための、
// 最もシンプルで、規約に準拠したパッケージ定義です。
let package = Package(
    name: "TBMKYApp",
    platforms: [
        .iOS(.v15)
    ],
    targets: [
        // ターゲット名を指定するだけで、Xcodeは規約に基づき
        // "Sources/TBMKYApp" 内の全ソースファイルを自動で認識します。
        // これにより、Info.plistも自動生成され、すべての問題が解決されます。
        .executableTarget(
            name: "TBMKYApp"
        )
    ]
)