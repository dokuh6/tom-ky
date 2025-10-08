import SwiftUI

// 記録の詳細を表示するためのビュー
struct RecordDetailView: View {

    let record: TBMRecord

    // 日付フォーマッタ
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

    var body: some View {
        Form {
            // MARK: - 基本情報セクション
            Section(header: Text("基本情報").font(.headline)) {
                InfoRow(label: "営業所", value: record.officeName)
                InfoRow(label: "日付", value: dateFormatter.string(from: record.date))
                InfoRow(label: "天候", value: record.weather)
                InfoRow(label: "電柱番号", value: record.poleNumber)

                // チェック項目
                CheckRow(label: "責任者", isChecked: record.isManager)
                CheckRow(label: "推進者", isChecked: record.isPromoter)
                CheckRow(label: "キーマン", isChecked: record.isKeyman)
                CheckRow(label: "副長", isChecked: record.isForeman)
                CheckRow(label: "発行者", isChecked: record.isIssuer)
                CheckRow(label: "班", isChecked: record.isSquad)
            }

            // MARK: - 作業内容セクション
            Section(header: Text("作業内容").font(.headline)) {
                Text(record.workContent.isEmpty ? "未入力" : record.workContent)
                    .foregroundColor(record.workContent.isEmpty ? .secondary : .primary)
            }

            // MARK: - 作業分担者名セクション
            Section(header: Text("作業分担者名").font(.headline)) {
                ForEach(record.workers.filter { !$0.name.isEmpty }) { worker in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(worker.name).bold()
                            if worker.isSupervisor {
                                Text("(班長)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        Text(worker.assignment)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }

            // MARK: - TBMK/Y セクション
            Section(header: Text("TBMK/Y (危険予知)").font(.headline)) {
                ForEach(record.kyItems.filter { !$0.content.isEmpty }) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("作業者: \(item.workerName)")
                            Spacer()
                            if item.isChecked {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        Text(item.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
                CheckRow(label: "班長指示による安全ポイント", isChecked: record.leaderSafetyPointCheck)
            }

            // MARK: - 各種チェックリスト
            Section(header: Text("チェックリスト").font(.headline)) {
                DisclosureGroup("作業方法") {
                    ForEach(0..<record.workMethodChecks.count, id: \.self) { index in
                        CheckRow(label: "項目 \(index + 1)", isChecked: record.workMethodChecks[index])
                    }
                }
                DisclosureGroup("作業後TBM") {
                    ForEach(0..<record.postWorkTBMChecks.count, id: \.self) { index in
                        CheckRow(label: "項目 \(index + 1)", isChecked: record.postWorkTBMChecks[index])
                    }
                }
                DisclosureGroup("TBM-KYチェックポイント") {
                    ForEach(0..<record.checkpoints.count, id: \.self) { index in
                        CheckRow(label: "項目 \(index + 1)", isChecked: record.checkpoints[index])
                    }
                }
            }

            // MARK: - その他
            Section(header: Text("その他").font(.headline)) {
                InfoRow(label: "結線図 電柱番号1", value: record.wiringDiagramPoleNumbers[0])
                InfoRow(label: "結線図 電柱番号2", value: record.wiringDiagramPoleNumbers[1])

                Text("営業所独自項目")
                Text(record.officeSpecificItems.isEmpty ? "未入力" : record.officeSpecificItems)
                     .foregroundColor(record.officeSpecificItems.isEmpty ? .secondary : .primary)

                Text("コメント")
                Text(record.comment.isEmpty ? "未入力" : record.comment)
                    .foregroundColor(record.comment.isEmpty ? .secondary : .primary)
            }

             // MARK: - 確認印セクション
            Section(header: Text("確認印").font(.headline)) {
                ForEach(record.confirmations.indices, id: \.self) { index in
                    if !record.confirmations[index].isEmpty {
                        InfoRow(label: "班員 \(index + 1)", value: record.confirmations[index])
                    }
                }
            }
        }
        .navigationTitle(dateFormatter.string(from: record.date))
        // .navigationBarTitleDisplayMode(.inline) はiOSでのみ利用可能なため、
        // プラットフォーム条件コンパイルで囲みます。
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Helper Views

// ラベルと値を表示するヘルパービュー
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value.isEmpty ? "未入力" : value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// ラベルとチェックマークを表示するヘルパービュー
struct CheckRow: View {
    let label: String
    let isChecked: Bool

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(isChecked ? .accentColor : .secondary)
        }
    }
}

// MARK: - プレビュー
struct RecordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用に詳細なダミーデータを作成
        let previewRecord: TBMRecord = {
            var record = TBMRecord()
            record.officeName = "プレビュー営業所"
            record.date = Date()
            record.weather = "晴れ"
            record.poleNumber = "中野-123"
            record.isManager = true
            record.workContent = "プレビュー用の作業内容です。長文のテストも兼ねて、ここにテキストを記述しています。"
            record.workers = [
                .init(name: "山田 太郎", assignment: "高所作業", isSupervisor: true),
                .init(name: "佐藤 次郎", assignment: "地上監視", isSupervisor: false)
            ]
            record.kyItems = [
                .init(workerName: "山田 太郎", isChecked: true, content: "工具の落下に注意する")
            ]
            record.workMethodChecks = [true, false, true, false, true]
            record.confirmations = ["鈴木", "田中", "", "", "", ""]
            return record
        }()

        NavigationView {
            RecordDetailView(record: previewRecord)
        }
        .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}