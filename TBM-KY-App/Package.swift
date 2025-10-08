// swift-tools-version:5.5
import PackageDescription

// Xcodeがプロジェクトを正しく自動認識できるよう、
// 最もシンプルで標準的なパッケージ定義に初期化します。
let package = Package(
    name: "TBM-KY-App",
    platforms: [
        .iOS(.v15)
    ],
    targets: [
        // ターゲット名を指定するだけで、Xcodeは規約に基づき
        // "Sources/TBMKYApp" 内の全ソースファイルを自動で認識します。
        .executableTarget(
            name: "TBMKYApp"
        )
    ]
)