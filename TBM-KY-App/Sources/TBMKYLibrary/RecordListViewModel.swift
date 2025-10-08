import SwiftUI

// RecordListViewのためのViewModel
// 保存された記録のリストを管理します。
class RecordListViewModel: ObservableObject {

    // @Publishedプロパティラッパーにより、records配列の変更が
    // Viewに自動的に通知され、UIが更新されます。
    @Published var records: [TBMRecord] = []

    // イニシャライザ
    init() {
        // ViewModelが初期化される際に、一度記録を読み込みます。
        loadRecords()
    }

    // 記録を読み込むメソッド
    // PersistenceServiceからデータを取得し、
    // 日付の降順（新しいものが上）に並び替えてプロパティにセットします。
    func loadRecords() {
        self.records = PersistenceService.shared.loadRecords().sorted(by: { $0.date > $1.date })
        print("\(self.records.count)件の記録を読み込みました。")
    }
}