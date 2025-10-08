import Foundation

// データの永続化（保存・読み込み）を管理するサービス
class PersistenceService {

    // シングルトンインスタンス
    // アプリ全体で唯一のインスタンスを共有するために使用します。
    static let shared = PersistenceService()

    // 保存先のファイルURLを計算するプライベートプロパティ
    private var fileURL: URL {
        // アプリのドキュメントディレクトリのURLを取得します。
        // ここは、ユーザーデータファイルを保存するのに最適な場所です。
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // 保存するファイル名を指定します。
        return directory.appendingPathComponent("tbm_records.json")
    }

    // プライベートイニシャライザ
    // 外部からのインスタンス化を防ぎ、シングルトンパターンを強制します。
    private init() {}

    // MARK: - Public Methods

    // 記録を読み込むメソッド
    // 保存されているすべてのTBMRecordの配列を返します。
    func loadRecords() -> [TBMRecord] {
        do {
            // 指定されたURLからデータを読み込みます。
            let data = try Data(contentsOf: fileURL)
            // JSONデコーダーを使って、Dataを[TBMRecord]に変換します。
            let records = try JSONDecoder().decode([TBMRecord].self, from: data)
            // 成功したら、記録の配列を返します。
            return records
        } catch {
            // ファイルが存在しない、またはデコードに失敗した場合など
            // エラーが発生した場合は、コンソールにエラーメッセージを出力し、空の配列を返します。
            print("記録の読み込みに失敗しました: \(error.localizedDescription)")
            return []
        }
    }

    // 記録を保存するメソッド
    // 新しい記録を追加、または既存の記録を更新します。
    func saveRecord(_ record: TBMRecord) {
        // まず、現在のすべての記録を読み込みます。
        var records = loadRecords()

        // 渡されたrecordがすでに存在するかどうかを確認します。
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            // 存在する場合（IDが一致）、その記録を更新します。
            records[index] = record
        } else {
            // 存在しない場合、新しい記録として配列の先頭に追加します。
            records.insert(record, at: 0)
        }

        // 更新された記録の配列をファイルに保存します。
        saveAllRecords(records)
    }

    // すべての記録をファイルに書き込むプライベートメソッド
    private func saveAllRecords(_ records: [TBMRecord]) {
        do {
            // JSONエンコーダーを準備します。
            // `prettyPrinted`オプションは、人間が読みやすいようにJSONを整形します（デバッグに便利）。
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            // [TBMRecord]をJSONデータにエンコードします。
            let data = try encoder.encode(records)

            // 指定されたファイルURLにデータを書き込みます。
            try data.write(to: fileURL, options: .atomic)
            print("記録が正常に保存されました。保存先: \(fileURL.path)")
        } catch {
            // エンコードまたは書き込みに失敗した場合、エラーメッセージをコンソールに出力します。
            print("記録の保存に失敗しました: \(error.localizedDescription)")
        }
    }
}