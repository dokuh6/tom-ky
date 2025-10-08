// swift-tools-version:5.5
import PackageDescription

// これが、Xcodeでプレビューとビルドを確実に行うための、
// 標準的で最も安定したパッケージ定義です。
let package = Package(
    name: "TBM-KY-App",
    platforms: [
        .iOS(.v15)
    ],
    // TBMKYLibrary を、このパッケージが外部に提供する「製品」として定義します。
    products: [
        .library(
            name: "TBMKYLibrary",
            targets: ["TBMKYLibrary"]),
    ],
    dependencies: [],
    // 2つのターゲット（ライブラリと実行ファイル）を定義します。
    targets: [
        // アプリケーションのUIとロジックを含むライブラリターゲット
        .target(
            name: "TBMKYLibrary",
            dependencies: []),
        // アプリケーションを起動するための実行可能ターゲット
        .executableTarget(
            name: "TBM-KY-App",
            dependencies: [
                // この実行ファイルが、TBMKYLibrary に依存することを明記します。
                "TBMKYLibrary"
            ]),
    ]
)