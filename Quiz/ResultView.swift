// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ResultView.swift
// 結果画面
// スコア・間違い一覧・復習ボタン
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct ResultView: View {

    @Binding var currentScreen:       Screen
    @Binding var score:               Int
    let totalQuestions:               Int
    let wrongQuizItems:               [QuizItem]
    let wrongInputQuizItems:          [InputQuizItem]
    let lastMode:                     QuizMode
    @Binding var playMode:            PlayMode
    @Binding var choiceQuestions:     [QuizItem]
    @Binding var inputQuestions:      [InputQuizItem]

    @State private var showScore = false

    private var scorePercent: Int {
        totalQuestions > 0 ? Int(Double(score) / Double(totalQuestions) * 100) : 0
    }

    private var scoreColor: Color {
        scorePercent >= 80 ? .appCorrect : scorePercent >= 50 ? .appTimerWarn : .appWrong
    }

    private var scoreMessage: String {
        switch scorePercent {
        case 100:       return "🎉 パーフェクト！コリラックマもびっくりクマ〜！✨"
        case 80..<100:  return "🐻 すごい！リラックマもニコニコだよ！もう少しで満点！"
        case 60..<80:   return "🌟 なかなかいい感じ！一緒に復習しよう！"
        case 40..<60:   return "🍀 半分できてるよ！間違いを見直そうクマ！"
        default:        return "🐻💦 ドンマイ！チャイロイコグマも応援してるよ！"
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // ── スコアカード ──
                    VStack(spacing: 10) {
                        Text(lastMode == .choice ? "選択式クイズ 結果" : "入力式クイズ 結果")
                            .font(.title3).fontWeight(.bold)
                            .foregroundStyle(Color.appPrimary.opacity(0.65))

                        Text("\(score)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundStyle(scoreColor)
                            .scaleEffect(showScore ? 1.0 : 0.4)
                            .opacity(showScore ? 1.0 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showScore)

                        Text("/ \(totalQuestions) 問  正答率 \(scorePercent)%")
                            .font(.title3).foregroundStyle(Color.appPrimary.opacity(0.75))

                        Text(scoreMessage)
                            .font(.body).multilineTextAlignment(.center)
                            .foregroundStyle(Color.appPrimary)
                            .padding(.horizontal, 8)
                    }
                    .padding(24).frame(maxWidth: .infinity)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
                    .padding(.horizontal, 20).padding(.top, 24)

                    // ── 選択式 間違い一覧 ──
                    if lastMode == .choice && !wrongQuizItems.isEmpty {
                        sectionHeader("❌ 間違えた問題 \(wrongQuizItems.count)問")
                        ForEach(wrongQuizItems) { item in
                            wrongCard(question: item.question,
                                      answer: item.options[item.correctAnswerIndex],
                                      category: item.category)
                        }
                        retryButton("🔁  間違えた問題だけもう一度") {
                            playMode = .retryWrong; score = 0
                            choiceQuestions = wrongQuizItems
                            currentScreen = .quiz
                        }
                    }

                    // ── 入力式 間違い一覧 ──
                    if lastMode == .input && !wrongInputQuizItems.isEmpty {
                        sectionHeader("❌ 間違えた問題 \(wrongInputQuizItems.count)問")
                        ForEach(wrongInputQuizItems) { item in
                            wrongCard(question: item.question, answer: item.correctAnswer, category: item.category)
                        }
                        retryButton("🔁  間違えた問題だけもう一度") {
                            playMode = .retryWrong; score = 0
                            inputQuestions = wrongInputQuizItems
                            currentScreen = .input
                        }
                    }

                    // ── タイトルへ ──
                    Button {
                        playMode = .normal
                        choiceQuestions.removeAll(); inputQuestions.removeAll()
                        currentScreen = .start
                    } label: {
                        Label("タイトルへ戻る", systemImage: "house.fill")
                            .font(.system(size: 17, weight: .bold))
                            .padding(.vertical, 16).frame(maxWidth: .infinity)
                            .background(Color.appButton)
                            .foregroundStyle(Color.appPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
                    }
                    .padding(.horizontal, 20).padding(.bottom, 36)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { showScore = true }
        }
    }

    // MARK: - パーツ

    func sectionHeader(_ title: String) -> some View {
        Text(title).font(.headline).fontWeight(.bold)
            .foregroundStyle(Color.appPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }

    func wrongCard(question: String, answer: String, category: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(category)
                .font(.caption2).fontWeight(.semibold)
                .foregroundStyle(Color.appAccent)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color.appAccent.opacity(0.12))
                .clipShape(Capsule())

            Text("Q. \(question)")
                .font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(Color.appPrimary)

            HStack {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.appCorrect)
                Text(answer).font(.subheadline).foregroundStyle(Color.appPrimary.opacity(0.75))
            }
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
        .padding(.horizontal, 20)
    }

    func retryButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 14).frame(maxWidth: .infinity)
                .background(Color.appButton)
                .foregroundStyle(Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        }
        .padding(.horizontal, 20)
    }
}
