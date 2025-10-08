import SwiftUI

// 保存された記録を一覧表示するビュー
struct RecordListView: View {

    // ViewModelを監視対象として指定
    @StateObject private var viewModel = RecordListViewModel()

    // 新規作成画面（InputView）の表示状態を管理するためのState
    @State private var isShowingInputView = false

    // 日付をフォーマットするためのプロパティ
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

    // イニシャライザ
    init() {}

    var body: some View {
        NavigationView {
            // viewModel.recordsが空の場合の表示
            if viewModel.records.isEmpty {
                Text("記録がありません。\n右上の「+」ボタンから新規作成してください。")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .navigationTitle("TBM記録一覧")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            addButton
                        }
                    }
            } else {
                // リスト形式で記録を表示
                List(viewModel.records) { record in
                    // 各行をタップするとRecordDetailViewに遷移する
                    NavigationLink(destination: RecordDetailView(record: record)) {
                        // 各行の表示内容
                        VStack(alignment: .leading, spacing: 5) {
                            Text(record.officeName)
                                .font(.headline)
                            Text(record.workContent)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1) // 1行に制限
                            Text(dateFormatter.string(from: record.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("TBM記録一覧")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
                }
            }
        }
        .onAppear {
            // 画面が表示されるたびに記録を再読み込みする
            viewModel.loadRecords()
        }
        .sheet(isPresented: $isShowingInputView, onDismiss: {
            // InputViewが閉じた後（保存またはキャンセル後）に、
            // リストを再読み込みして最新の状態を反映します。
            viewModel.loadRecords()
        }) {
            // isShowingInputViewがtrueになったら、InputViewをモーダルで表示します。
            InputView()
        }
    }

    // 新規作成ボタンのビュー
    private var addButton: some View {
        Button(action: {
            // ボタンが押されたら、isShowingInputViewをtrueにしてモーダルを表示
            isShowingInputView = true
        }) {
            Image(systemName: "plus")
        }
    }
}

// MARK: - プレビュー
struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用にPersistenceServiceにダミーデータを注入することも可能ですが、
        // ここでは単純にビューを表示します。
        RecordListView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}