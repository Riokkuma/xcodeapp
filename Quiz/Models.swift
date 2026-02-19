// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Models.swift
// アプリ全体で使うデータ構造・Enumを定義
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import Foundation

// MARK: - クイズデータ

/// 選択式クイズ1問分
struct QuizItem: Identifiable, Equatable {
    let id = UUID()
    let question: String        // 問題文
    let options: [String]       // 選択肢（4択）
    let correctAnswerIndex: Int // 正解のインデックス（0〜3）
    let category: String        // 分野名

    static func == (lhs: QuizItem, rhs: QuizItem) -> Bool { lhs.id == rhs.id }
}

/// 入力式クイズ1問分
struct InputQuizItem: Identifiable, Equatable {
    let id = UUID()
    let question: String    // 問題文
    let correctAnswer: String // 正解（文字列）
    let category: String    // 分野名

    static func == (lhs: InputQuizItem, rhs: InputQuizItem) -> Bool { lhs.id == rhs.id }
}

// MARK: - 保存用データ（UserDefaults）

/// 1回のプレイ履歴
struct QuizHistory: Codable, Identifiable {
    let id: UUID
    let date: Date
    let score: Int
    let total: Int
    let mode: String        // "choice" or "input"
    let categories: [String]

    var percent: Double { total > 0 ? Double(score) / Double(total) : 0 }
}

/// 間違いノート1件
struct WrongNote: Codable, Identifiable {
    let id: UUID
    let question: String
    let correctAnswer: String
    let category: String
    let mode: String
    var missCount: Int      // 何回間違えたか
    let lastMissed: Date
}

// MARK: - Enum

/// 画面の種類
enum Screen {
    case start      // タイトル画面
    case quiz       // 選択式クイズ
    case input      // 入力式クイズ
    case result     // 結果画面
    case history    // 学習履歴
    case wrongNote  // 間違いノート
}

/// クイズの形式
enum QuizMode {
    case choice // 選択式
    case input  // 入力式
}

/// 出題モード
enum PlayMode {
    case normal      // 通常出題
    case retryWrong  // 間違い復習
}
