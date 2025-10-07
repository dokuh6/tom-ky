// swift-tools-version:5.5
import PackageDescription

let package = Package(
    // パッケージ（プロジェクト）の名前
    name: "TBM-KY-App",
    // サポートするプラットフォームとバージョンの指定
    // iPad (iOS) と Mac (macOS) の両方に対応させ、最低バージョンを指定します。
    // これにより、ビルドターゲットがMacに設定された際のコンパイルエラーを防ぎます。
    platforms: [
        .iOS(.v15), .macOS(.v11)
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