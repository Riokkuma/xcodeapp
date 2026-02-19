// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// InputQuizView.swift
// 入力式クイズ画面（記述式）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct InputQuizView: View {

    @Binding var currentScreen:       Screen
    @Binding var score:               Int
    @Binding var totalQuestions:      Int
    @Binding var wrongInputQuizItems: [InputQuizItem]
    @Binding var questions:           [InputQuizItem]
    @EnvironmentObject var dataManager: DataManager

    @FocusState private var isFocused: Bool

    private let defaultQuizItems: [InputQuizItem] = [
        InputQuizItem(question: "自己増殖してネットワークを通じて感染を拡大するマルウェアは？",      correctAnswer: "ワーム",          category: "セキュリティ"),
        InputQuizItem(question: "関係データベースで、レコードを一意に識別する属性は？",              correctAnswer: "主キー",          category: "データベース"),
        InputQuizItem(question: "CPUと主記憶の間に配置され、処理速度向上を目的とするものは？",       correctAnswer: "キャッシュメモリ",  category: "ハードウェア"),
        InputQuizItem(question: "ソフトウェア開発工程で、利用者の要求を明確化する工程は？",          correctAnswer: "要件定義",        category: "ソフトウェア開発"),
        InputQuizItem(question: "自社の強み・弱みと、機会・脅威を分析する手法は？",                 correctAnswer: "SWOT分析",        category: "経営戦略"),
        InputQuizItem(question: "プロジェクトに利害関係を持ち、成果や進行に影響を与える人や組織は？", correctAnswer: "ステークホルダ",    category: "プロジェクト管理"),
        InputQuizItem(question: "暗号化で、送受信者が同じ鍵を共有する方式は？",                    correctAnswer: "共通鍵暗号方式",   category: "セキュリティ"),
        InputQuizItem(question: "OSI参照モデルで、通信経路の選択を行う層は？",                     correctAnswer: "ネットワーク層",   category: "ネットワーク"),
        InputQuizItem(question: "アジャイル開発の短い反復サイクルを繰り返す手法は？",               correctAnswer: "スクラム",         category: "ソフトウェア開発"),
        InputQuizItem(question: "IPアドレスとMACアドレスの対応を解決するプロトコルは？",             correctAnswer: "ARP",             category: "ネットワーク"),
    ]

    @State private var currentQuestionIndex = 0
    @State private var userInput: String    = ""
    @State private var isCorrect: Bool?     = nil

    var currentQuestion: InputQuizItem { questions[currentQuestionIndex] }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if questions.isEmpty {
                Text("問題を準備中だよ🐻").foregroundStyle(Color.appPrimary)
            } else {
                VStack(spacing: 0) {

                    // ── ヘッダー ──
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("入力式クイズ")
                                .font(.headline).fontWeight(.bold).foregroundStyle(Color.appPrimary)
                            Text(currentQuestion.category)
                                .font(.caption).foregroundStyle(Color.appAccent)
                        }
                        Spacer()
                        Text("\(currentQuestionIndex + 1) / \(questions.count)")
                            .font(.subheadline).foregroundStyle(Color.appPrimary.opacity(0.6))
                    }
                    .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 20)

                    // ── 問題文 ──
                    Text(currentQuestion.question)
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.appPrimary)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)

                    Spacer()

                    // ── 入力・ボタン ──
                    VStack(spacing: 12) {
                        TextField("ここに答えを入力してね🐻", text: $userInput)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 17))
                            .focused($isFocused)
                            .disabled(isCorrect != nil)
                            .padding(.horizontal, 20)

                        Button("答え合わせ") { checkAnswer() }
                            .font(.system(size: 17, weight: .bold))
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                userInput.isEmpty || isCorrect != nil
                                ? Color.appButton.opacity(0.4)
                                : Color.appButton
                            )
                            .foregroundStyle(Color.appPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
                            .disabled(userInput.isEmpty || isCorrect != nil)
                            .padding(.horizontal, 20)
                    }

                    // ── フィードバック ──
                    if let correct = isCorrect {
                        VStack(spacing: 8) {
                            Text(correct ? "正解！🎉 すごいクマ！" : "不正解… 🐻💦")
                                .font(.headline)
                                .foregroundStyle(correct ? Color.appCorrect : Color.appWrong)

                            if !correct {
                                HStack {
                                    Text("正解：").foregroundStyle(Color.appPrimary.opacity(0.6))
                                    Text(currentQuestion.correctAnswer)
                                        .fontWeight(.bold).foregroundStyle(Color.appPrimary)
                                }
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                        }
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .scale))
                    }

                    Spacer()

                    // ── 次へ ──
                    Button("次へ →") { goNext() }
                        .font(.system(size: 17, weight: .bold))
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(isCorrect == nil ? Color.appButton.opacity(0.3) : Color.appButton)
                        .foregroundStyle(Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
                        .disabled(isCorrect == nil)
                        .padding(.horizontal, 20).padding(.bottom, 32)
                }
                .animation(.easeInOut(duration: 0.2), value: isCorrect)
            }
        }
        .onTapGesture { isFocused = false }
        .onAppear {
            score = 0; wrongInputQuizItems.removeAll()
            currentQuestionIndex = 0; userInput = ""; isCorrect = nil
            if questions.isEmpty { questions = defaultQuizItems.shuffled() }
            totalQuestions = questions.count
        }
    }

    func checkAnswer() {
        isFocused = false
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let correct = currentQuestion.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased() == correct.lowercased() {
            isCorrect = true; score += 1
        } else {
            isCorrect = false
            if !wrongInputQuizItems.contains(currentQuestion) {
                wrongInputQuizItems.append(currentQuestion)
                dataManager.addWrongNote(
                    question: currentQuestion.question,
                    correctAnswer: currentQuestion.correctAnswer,
                    category: currentQuestion.category, mode: "input"
                )
            }
        }
    }

    func goNext() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1; userInput = ""; isCorrect = nil
        } else {
            let cats = Array(Set(questions.map { $0.category }))
            dataManager.saveHistory(score: score, total: questions.count, mode: "input", categories: cats)
            currentScreen = .result
        }
    }
}
