import SwiftUI

// InputViewのためのViewModel
// 画面のロジックと状態管理を担当します。
class InputViewModel: ObservableObject {

    // @Publishedプロパティラッパーを使用することで、
    // このプロパティが変更された際に、関連するViewが自動的に更新されます。
    @Published var record: TBMRecord

    // イニシャライザ
    // 新しい記録を作成する場合と、既存の記録を編集する場合の両方に対応できます。
    // 引数でrecordが渡されなければ、新しい空のTBMRecordを生成します。
    init(record: TBMRecord? = nil) {
        if let existingRecord = record {
            self.record = existingRecord
        } else {
            self.record = TBMRecord()
        }
    }

    // データを保存するメソッド
    // PersistenceServiceのシングルトンインスタンスを呼び出して、
    // 現在の記録データをデバイスに保存します。
    func saveRecord() {
        PersistenceService.shared.saveRecord(record)
        print("記録が保存されました: \(record.id)")
    }
}