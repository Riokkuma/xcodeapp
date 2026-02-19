// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DataManager.swift
// 学習履歴・間違いノートをUserDefaultsに保存
// アプリを閉じてもデータが残る
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import Foundation

class DataManager: ObservableObject {

    // シングルトン（アプリ全体で1つだけ使う）
    static let shared = DataManager()

    private let historyKey  = "quiz_history"
    private let wrongKey    = "wrong_notes"

    @Published var histories:   [QuizHistory] = []
    @Published var wrongNotes:  [WrongNote]   = []

    private init() { loadAll() }

    // MARK: - 読み込み

    func loadAll() {
        histories  = load([QuizHistory].self, key: historyKey) ?? []
        wrongNotes = load([WrongNote].self,   key: wrongKey)   ?? []
    }

    private func load<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    // MARK: - 履歴保存

    func saveHistory(score: Int, total: Int, mode: String, categories: [String]) {
        let h = QuizHistory(id: UUID(), date: Date(), score: score,
                            total: total, mode: mode, categories: categories)
        histories.insert(h, at: 0)
        if histories.count > 30 { histories = Array(histories.prefix(30)) }
        save(histories, key: historyKey)
    }

    // MARK: - 間違いノート

    func addWrongNote(question: String, correctAnswer: String, category: String, mode: String) {
        if let i = wrongNotes.firstIndex(where: { $0.question == question }) {
            wrongNotes[i].missCount += 1
        } else {
            wrongNotes.append(WrongNote(
                id: UUID(), question: question, correctAnswer: correctAnswer,
                category: category, mode: mode, missCount: 1, lastMissed: Date()
            ))
        }
        save(wrongNotes, key: wrongKey)
    }

    func clearWrongNotes() {
        wrongNotes.removeAll()
        save(wrongNotes, key: wrongKey)
    }

    // MARK: - 統計

    /// 直近7回の正答率（グラフ用）
    var recentScores: [Double] {
        Array(histories.prefix(7).map { $0.percent }.reversed())
    }

    /// 連続学習日数（ストリーク）
    var streakDays: Int {
        var streak = 0
        var check = Calendar.current.startOfDay(for: Date())
        for h in histories {
            let d = Calendar.current.startOfDay(for: h.date)
            if d == check {
                streak += 1
                check = Calendar.current.date(byAdding: .day, value: -1, to: check)!
            } else if d < check { break }
        }
        return streak
    }

    // MARK: - Private

    private func save<T: Codable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
