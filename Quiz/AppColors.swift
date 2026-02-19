// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// AppColors.swift
// アプリ全体の色とボタンスタイルを定義
// ここを変えるだけで全体のデザインが変わる
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

extension Color {
    // ベースカラー（リラックマカラー🐻）
    static let appBackground  = Color(red: 0.96, green: 0.93, blue: 0.86) // クリーム背景
    static let appPrimary     = Color(red: 0.28, green: 0.18, blue: 0.08) // ダークブラウン文字
    static let appButton      = Color.white                                // ボタン背景
    static let appAccent      = Color(red: 0.75, green: 0.50, blue: 0.20) // ゴールドブラウン
    static let appCard        = Color(red: 1.0,  green: 0.98, blue: 0.93) // カード背景
    static let appCorrect     = Color(red: 0.20, green: 0.65, blue: 0.35) // 正解グリーン
    static let appWrong       = Color(red: 0.80, green: 0.20, blue: 0.20) // 不正解レッド
    static let appTimerNormal = Color(red: 0.20, green: 0.65, blue: 0.35) // タイマー緑
    static let appTimerWarn   = Color(red: 0.85, green: 0.55, blue: 0.10) // タイマー黄
    static let appTimerDanger = Color(red: 0.80, green: 0.20, blue: 0.20) // タイマー赤
}

// 大きいボタン共通スタイル
struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 300)
            .background(Color.appButton)
            .foregroundColor(Color.appPrimary)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
