// swift-tools-version:5.5
import PackageDescription

let package = Package(
    // パッケージ（プロジェクト）の名前
    name: "TBM-KY-App",
    // サポートするプラットフォームとバージョンの指定
    // iPadアプリなので、.iOSを指定し、バージョンをv15とします。
    platforms: [
        .iOS(.v15)
    ],
    // このパッケージが生成するプロダクト（成果物）の定義
    products: [
        // TBMKYAppという名前の実行可能ファイル（アプリ）を定義します。
        .executable(
            name: "TBMKYApp",
            targets: ["TBMKYApp"])
    ],
    // 依存関係の定義（今回は外部ライブラリを使用しないため空）
    dependencies: [],
    // ターゲット（ソースコードの集合）の定義
    targets: [
        // アプリケーションを構成する実行可能ターゲット
        .executableTarget(
            // ターゲット名
            name: "TBMKYApp",
            // ソースファイルが格納されているパス
            // デフォルトは "Sources/TBMKYApp" ですが、明示的に指定します。
            path: "Sources/TBMKYApp"
        )
    ]
)