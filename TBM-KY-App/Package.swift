// swift-tools-version:5.5
import PackageDescription

let package = Package(
    // パッケージ（プロジェクト）の名前
    name: "TBM-KY-App",
    // サポートするプラットフォームとバージョンの指定
    // iPad (iOS) と Mac (macOS) の両方に対応させ、最低バージョンを指定します。
    // 'dismiss'などのAPIがmacOS 12.0以降で利用可能なため、バージョンをv12に設定します。
    platforms: [
        .iOS(.v15), .macOS(.v12)
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
            path: "Sources/TBMKYApp",
            // リンカ設定を追加して、Info.plistを実行ファイルに直接埋め込みます。
            // これが、バンドルIDをシステムに認識させるための正しい方法です。
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Sources/TBMKYApp/Resources/Info.plist"
                ])
            ]
        )
    ]
)