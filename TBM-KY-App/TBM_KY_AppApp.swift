import SwiftUI

// SwiftUIアプリケーションのエントリーポイント（起動点）
// @main属性が、この構造体がアプリの起動を担当することを示します。
@main
struct TBM_KY_AppApp: App {
    var body: some Scene {
        // WindowGroupは、アプリのUI階層のルートを定義します。
        // ここに指定されたビューが、アプリ起動時に表示される最初の画面となります。
        WindowGroup {
            // RecordListViewをアプリのメインビューとして設定します。
            RecordListView()
        }
    }
}