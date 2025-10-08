import Foundation

// TBM-KYの記録全体を管理するデータモデル
struct TBMRecord: Codable, Identifiable {
    // 各記録を一意に識別するためのID
    var id = UUID()

    // MARK: - ヘッダー情報

    // 営業所名
    var officeName: String = ""
    // 責任者（チェック）
    var isManager: Bool = false
    // 推進者（チェック）
    var isPromoter: Bool = false
    // キーマン（チェック）
    var isKeyman: Bool = false
    // 副長（チェック）
    var isForeman: Bool = false
    // 発行者（チェック）
    var isIssuer: Bool = false
    // 班（チェック）
    var isSquad: Bool = false

    // MARK: - 日付・天候・場所

    // 記録日
    var date: Date = Date()
    // 天候
    var weather: String = ""
    // 電柱番号
    var poleNumber: String = ""

    // MARK: - 作業情報

    // 作業内容
    var workContent: String = ""

    // 作業分担者リスト（6名まで）
    var workers: [Worker] = Array(repeating: Worker(), count: 6)

    // MARK: - 作業方法と安全対策

    // 作業方法のチェック項目（5項目）
    var workMethodChecks: [Bool] = Array(repeating: false, count: 5)

    // TBMK/Y（危険予知）リスト（4項目）
    var kyItems: [KYItem] = Array(repeating: KYItem(), count: 4)

    // 班長指示による安全ポイント（チェック）
    var leaderSafetyPointCheck: Bool = false

    // MARK: - 作業後TBM

    // 作業後TBMのチェック項目（5項目）
    var postWorkTBMChecks: [Bool] = Array(repeating: false, count: 5)

    // MARK: - その他

    // コメント
    var comment: String = ""

    // 確認印（確認者の名前を保存）
    var confirmations: [String] = Array(repeating: "", count: 6)

    // MARK: - TBM-KYチェックポイント (別紙)

    // チェックポイントの項目（10項目）
    var checkpoints: [Bool] = Array(repeating: false, count: 10)

    // 結線図の電柱番号
    var wiringDiagramPoleNumbers: [String] = ["", ""]

    // 営業所独自項目
    var officeSpecificItems: String = ""

    // MARK: - Nested Structs

    // 作業分担者の情報を管理する構造体
    struct Worker: Codable, Identifiable {
        var id = UUID()
        // 作業者名
        var name: String = ""
        // 作業分担内容
        var assignment: String = ""
        // 班長（作業監督者）かどうか
        var isSupervisor: Bool = false
    }

    // K（危険）Y（予知）項目の情報を管理する構造体
    struct KYItem: Codable, Identifiable {
        var id = UUID()
        // 作業者名
        var workerName: String = ""
        // チェック
        var isChecked: Bool = false
        // K（危険）Y（予知）内容
        var content: String = ""
    }
}