// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// StartView.swift
// タイトル・ホーム画面
// 統計カード・クイズ開始・サブメニュー
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct StartView: View {

    @Binding var currentScreen: Screen
    @Binding var lastMode: QuizMode
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── タイトル ──
                VStack(spacing: 4) {
                    Text("🐻 基本情報クイズ")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.appPrimary)
                    Text("一緒に合格を目指そう！")
                        .font(.subheadline)
                        .foregroundStyle(Color.appPrimary.opacity(0.55))
                }
                .padding(.top, 48)
                .padding(.bottom, 24)

                // ── 統計カード（3つ横並び） ──
                HStack(spacing: 10) {
                    statCard(icon: "🔥", value: "\(dataManager.streakDays)", label: "連続日数")
                    statCard(
                        icon: "📊",
                        value: dataManager.histories.isEmpty
                            ? "--"
                            : "\(Int((dataManager.histories.first?.percent ?? 0) * 100))%",
                        label: "最新正答率"
                    )
                    statCard(icon: "📝", value: "\(dataManager.histories.count)", label: "総プレイ数")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // ── クイズ開始ボタン ──
                VStack(spacing: 14) {
                    quizButton(
                        icon: "list.bullet.rectangle",
                        title: "選択式クイズ",
                        subtitle: "4択・タイムアタック 🕐"
                    ) {
                        lastMode = .choice
                        currentScreen = .quiz
                    }

                    quizButton(
                        icon: "pencil.and.list.clipboard",
                        title: "入力式クイズ",
                        subtitle: "記述で深く定着させよう ✏️"
                    ) {
                        lastMode = .input
                        currentScreen = .input
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // ── サブメニュー ──
                HStack(spacing: 16) {
                    subMenuButton(icon: "chart.line.uptrend.xyaxis", label: "学習履歴") {
                        currentScreen = .history
                    }
                    subMenuButton(icon: "note.text", label: "間違いノート") {
                        currentScreen = .wrongNote
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - パーツ

    func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(icon).font(.title2)
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.appPrimary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color.appPrimary.opacity(0.55))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    func quizButton(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.appPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.appPrimary.opacity(0.5))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.appPrimary.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
    }

    func subMenuButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color.appAccent)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.appPrimary.opacity(0.7))
            }
            .frame(width: 120, height: 64)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
}

#Preview {
    @Previewable @State var currentScreen: Screen = .start
    @Previewable @State var lastMode: QuizMode = .choice
    StartView(currentScreen: $currentScreen, lastMode: $lastMode)
        .environmentObject(DataManager.shared)
}
