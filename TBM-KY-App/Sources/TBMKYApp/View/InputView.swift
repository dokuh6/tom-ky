import SwiftUI

// データ入力のためのメインビュー
struct InputView: View {

    // このビューを閉じるためのdismissアクションを取得
    @Environment(\.dismiss) var dismiss

    // ViewModelを監視対象として指定
    @StateObject private var viewModel: InputViewModel

    // イニシャライザ
    init(record: TBMRecord? = nil) {
        _viewModel = StateObject(wrappedValue: InputViewModel(record: record))
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: - 基本情報セクション
                Section(header: Text("基本情報").font(.headline)) {
                    HStack {
                        Text("営業所")
                        TextField("例：〇〇営業所", text: $viewModel.record.officeName)
                            .multilineTextAlignment(.trailing)
                    }
                    // チェックボックス群
                    Toggle("責任者", isOn: $viewModel.record.isManager)
                    Toggle("推進者", isOn: $viewModel.record.isPromoter)
                    Toggle("キーマン", isOn: $viewModel.record.isKeyman)
                    Toggle("副長", isOn: $viewModel.record.isForeman)
                    Toggle("発行者", isOn: $viewModel.record.isIssuer)
                    Toggle("班", isOn: $viewModel.record.isSquad)
                }

                // MARK: - 日付・場所セクション
                Section {
                    DatePicker("日付", selection: $viewModel.record.date, displayedComponents: .date)
                    HStack {
                        Text("天候")
                        TextField("例：晴れ", text: $viewModel.record.weather)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("電柱番号")
                        TextField("例：123-45", text: $viewModel.record.poleNumber)
                            .multilineTextAlignment(.trailing)
                    }
                }

                // MARK: - 作業内容セクション
                Section(header: Text("作業内容").font(.headline)) {
                    TextEditor(text: $viewModel.record.workContent)
                        .frame(height: 100)
                }

                // MARK: - 作業分担者名セクション
                Section(header: Text("作業分担者名").font(.headline)) {
                    // $viewModel.record.workers の各要素にアクセスするためにインデックスを使用
                    ForEach(viewModel.record.workers.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Toggle("班長(作業監督者)", isOn: $viewModel.record.workers[index].isSupervisor)
                            HStack {
                                Text("作業者名")
                                TextField("名前", text: $viewModel.record.workers[index].name)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("作業分担")
                                TextField("分担内容", text: $viewModel.record.workers[index].assignment)
                                     .multilineTextAlignment(.trailing)
                            }
                        }
                        // 最後の要素以外には区切り線を入れる
                        if index < viewModel.record.workers.count - 1 {
                            Divider()
                        }
                    }
                }

                // MARK: - 作業方法セクション
                Section(header: Text("作業方法").font(.headline)) {
                    ForEach(0..<viewModel.record.workMethodChecks.count, id: \.self) { index in
                        Toggle("チェック項目 \(index + 1)", isOn: $viewModel.record.workMethodChecks[index])
                    }
                }

                // MARK: - TBMK/Y セクション
                Section(header: Text("TBMK/Y (危険予知)").font(.headline)) {
                    ForEach(viewModel.record.kyItems.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("作業者名")
                                TextField("名前", text: $viewModel.record.kyItems[index].workerName)
                                    .multilineTextAlignment(.trailing)
                                Toggle("", isOn: $viewModel.record.kyItems[index].isChecked)
                                    .labelsHidden()
                            }
                            Text("K Y 内容")
                            TextEditor(text: $viewModel.record.kyItems[index].content)
                                .frame(height: 50)
                        }
                        if index < viewModel.record.kyItems.count - 1 {
                            Divider()
                        }
                    }
                    Toggle("班長指示による安全ポイント", isOn: $viewModel.record.leaderSafetyPointCheck)
                }

                // MARK: - 作業後TBMセクション
                Section(header: Text("作業後TBM").font(.headline)) {
                    ForEach(0..<viewModel.record.postWorkTBMChecks.count, id: \.self) { index in
                        Toggle("チェック項目 \(index + 1)", isOn: $viewModel.record.postWorkTBMChecks[index])
                    }
                }

                // MARK: - コメントセクション
                Section(header: Text("コメント").font(.headline)) {
                    TextEditor(text: $viewModel.record.comment)
                        .frame(height: 100)
                }

                // MARK: - 確認印セクション
                Section(header: Text("確認印").font(.headline)) {
                    // グリッドレイアウトで確認者欄を表示
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.record.confirmations.indices, id: \.self) { index in
                            VStack {
                                Text("班員 \(index + 1)")
                                TextField("確認者名", text: $viewModel.record.confirmations[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                }

                // MARK: - TBM-KYチェックポイントセクション (別紙)
                Section(header: Text("TBM-KYチェックポイント").font(.headline)) {
                    // チェックリストのタイトル
                    Text("活線・活線接近作業に〜").font(.subheadline).bold()
                    ForEach(0..<10, id: \.self) { index in
                        Toggle("チェック項目 \(index + 1)", isOn: $viewModel.record.checkpoints[index])
                    }

                    Text("結線図").font(.subheadline).bold().padding(.top)
                    HStack {
                        Text("電柱番号")
                        TextField("", text: $viewModel.record.wiringDiagramPoleNumbers[0])
                    }
                     HStack {
                        Text("電柱番号")
                        TextField("", text: $viewModel.record.wiringDiagramPoleNumbers[1])
                    }

                    Text("営業所独自項目").font(.subheadline).bold().padding(.top)
                    TextEditor(text: $viewModel.record.officeSpecificItems)
                        .frame(height: 100)
                }
            }
            .navigationTitle("TBM記録票")
            .toolbar {
                // ナビゲーションバーの右側にボタンを配置
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        viewModel.saveRecord()
                        dismiss() // ビューを閉じる
                    }
                }
                // ナビゲーションバーの左側にボタンを配置
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss() // ビューを閉じる
                    }
                }
            }
        }
        .navigationViewStyle(.stack) // iPadでの表示崩れを防ぐ
    }
}

// MARK: - プレビュー
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewInterfaceOrientation(.portrait)
    }
}