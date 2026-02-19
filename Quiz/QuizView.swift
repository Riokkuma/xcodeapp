// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// QuizView.swift
// 選択式クイズ画面（4択・タイムアタック）
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct QuizView: View {

    @Binding var currentScreen:  Screen
    @Binding var score:          Int
    @Binding var totalQuestions: Int
    @Binding var wrongQuizItems: [QuizItem]
    @Binding var questions:      [QuizItem]
    @EnvironmentObject var dataManager: DataManager

    // ── 全問題データ（カテゴリ付き）──
    private let allQuizItems: [QuizItem] = [
        // ネットワーク
        QuizItem(question: "TCPの特徴として正しいものはどれか。",
                 options: ["コネクションレス型である","データの到達保証を行わない","順序制御や再送制御を行う","主に音声通信で使用される"],
                 correctAnswerIndex: 2, category: "ネットワーク"),
        QuizItem(question: "OSI参照モデルで、通信経路の選択（ルーティング）を担う層はどれか。",
                 options: ["データリンク層","トランスポート層","ネットワーク層","セッション層"],
                 correctAnswerIndex: 2, category: "ネットワーク"),
        QuizItem(question: "IPアドレスとMACアドレスの対応を解決するプロトコルはどれか。",
                 options: ["DNS","DHCP","ARP","ICMP"],
                 correctAnswerIndex: 2, category: "ネットワーク"),
        // セキュリティ
        QuizItem(question: "自己増殖してネットワークを通じて感染を拡大するマルウェアはどれか。",
                 options: ["スパイウェア","ワーム","トロイの木馬","アドウェア"],
                 correctAnswerIndex: 1, category: "セキュリティ"),
        QuizItem(question: "暗号化方式のうち、送信者と受信者が同じ鍵を使う方式はどれか。",
                 options: ["公開鍵暗号方式","共通鍵暗号方式","ハイブリッド暗号方式","ディジタル署名"],
                 correctAnswerIndex: 1, category: "セキュリティ"),
        QuizItem(question: "第三者機関が公開鍵の正当性を保証するために発行するものはどれか。",
                 options: ["ディジタル署名","ディジタル証明書","共通鍵","ハッシュ値"],
                 correctAnswerIndex: 1, category: "セキュリティ"),
        // データベース
        QuizItem(question: "関係データベースで、レコードを一意に識別する属性はどれか。",
                 options: ["主キー","外部キー","インデックス","NULL値属性"],
                 correctAnswerIndex: 0, category: "データベース"),
        QuizItem(question: "他のテーブルの主キーを参照する属性はどれか。",
                 options: ["主キー","候補キー","外部キー","複合キー"],
                 correctAnswerIndex: 2, category: "データベース"),
        QuizItem(question: "SQLで、条件に合う行を絞り込む句はどれか。",
                 options: ["GROUP BY","ORDER BY","WHERE","HAVING"],
                 correctAnswerIndex: 2, category: "データベース"),
        // ハードウェア
        QuizItem(question: "CPUと主記憶の間に配置され、処理速度向上を目的とするものはどれか。",
                 options: ["補助記憶装置","キャッシュメモリ","仮想記憶","レジスタ"],
                 correctAnswerIndex: 1, category: "ハードウェア"),
        QuizItem(question: "プロセスは1つ以上のスレッドを持つ。この関係として正しいものはどれか。",
                 options: ["スレッドは複数のプロセスを管理する","プロセスはスレッドの一部である","プロセスは1つ以上のスレッドを持つ","スレッドはOSとは無関係である"],
                 correctAnswerIndex: 2, category: "ハードウェア"),
        QuizItem(question: "システムの一部が故障しても全体の機能を維持しようとする設計方針はどれか。",
                 options: ["フールプルーフ","フェールセーフ","フォールトトレランス","フェールソフト"],
                 correctAnswerIndex: 2, category: "ハードウェア"),
        // ソフトウェア開発
        QuizItem(question: "ソフトウェア開発工程で、利用者の要求を明確化する工程はどれか。",
                 options: ["詳細設計","実装","要件定義","テスト"],
                 correctAnswerIndex: 2, category: "ソフトウェア開発"),
        QuizItem(question: "アジャイル開発手法の1つで、短い反復サイクルを繰り返す手法はどれか。",
                 options: ["ウォーターフォール","スクラム","プロトタイプ","スパイラル"],
                 correctAnswerIndex: 1, category: "ソフトウェア開発"),
        QuizItem(question: "UMLで、クラス間の関係やシステム構造を静的に表すダイアグラムはどれか。",
                 options: ["シーケンス図","ユースケース図","クラス図","アクティビティ図"],
                 correctAnswerIndex: 2, category: "ソフトウェア開発"),
        // プロジェクト管理
        QuizItem(question: "プロジェクトに利害関係を持ち、成果や進行に影響を与える人や組織を何というか。",
                 options: ["プロジェクトメンバ","ユーザ","ステークホルダ","クライアント"],
                 correctAnswerIndex: 2, category: "プロジェクト管理"),
        QuizItem(question: "ITサービスマネジメントで、障害発生時に原因を特定し再発防止を行うプロセスはどれか。",
                 options: ["インシデント管理","問題管理","変更管理","構成管理"],
                 correctAnswerIndex: 1, category: "プロジェクト管理"),
        // 経営戦略
        QuizItem(question: "自社の強み・弱みと、機会・脅威を分析する手法はどれか。",
                 options: ["PEST分析","SWOT分析","バリューチェーン分析","ファイブフォース分析"],
                 correctAnswerIndex: 1, category: "経営戦略"),
        QuizItem(question: "企業の経営戦略に基づき、情報システムの全体方針を定めるものはどれか。",
                 options: ["システム要件定義","システム化計画","運用設計","テスト計画"],
                 correctAnswerIndex: 1, category: "経営戦略"),
    ]

    @State private var currentQuestionIndex = 0
    @State private var isCorrect            = false
    @State private var isShowingFeedback    = false
    @State private var selectedIndex: Int?  = nil

    private let timeLimit: Double = 10.0
    @State private var timeRemaining: Double = 10.0
    @State private var timerRunning = false

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var timerColor: Color {
        if timeRemaining > 5 { return .appTimerNormal }
        if timeRemaining > 3 { return .appTimerWarn }
        return .appTimerDanger
    }

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
                            Text("選択式クイズ")
                                .font(.headline).fontWeight(.bold)
                                .foregroundStyle(Color.appPrimary)
                            Text(questions[currentQuestionIndex].category)
                                .font(.caption).foregroundStyle(Color.appAccent)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                                .font(.subheadline).foregroundStyle(Color.appPrimary.opacity(0.6))
                            Text(String(format: "%.0f 秒", ceil(timeRemaining)))
                                .font(.headline).fontWeight(.bold).foregroundStyle(timerColor)
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 8)

                    // ── タイマーバー ──
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.4)).frame(height: 8)
                            RoundedRectangle(cornerRadius: 4).fill(timerColor)
                                .frame(width: geo.size.width * max(0, min(timeRemaining / timeLimit, 1)), height: 8)
                                .animation(.linear(duration: 0.1), value: timeRemaining)
                        }
                    }
                    .frame(height: 8).padding(.horizontal, 20).padding(.bottom, 16)

                    // ── 問題文 ──
                    Text(questions[currentQuestionIndex].question)
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

                    // ── フィードバック ──
                    if isShowingFeedback {
                        Text(isCorrect
                             ? "正解！🎉"
                             : "不正解… 正解は「\(questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex])」")
                            .font(.subheadline).fontWeight(.semibold)
                            .foregroundStyle(isCorrect ? Color.appCorrect : Color.appWrong)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .transition(.opacity.combined(with: .scale))
                    }

                    Spacer()

                    // ── 選択肢ボタン ──
                    VStack(spacing: 10) {
                        ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                            Button {
                                timerRunning = false
                                answerTapped(index)
                            } label: {
                                HStack(spacing: 14) {
                                    Text(["Ａ","Ｂ","Ｃ","Ｄ"][index])
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(Color.appPrimary.opacity(0.45))
                                        .frame(width: 26)
                                    Text(questions[currentQuestionIndex].options[index])
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.appPrimary)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.horizontal, 16).padding(.vertical, 14)
                                .background(choiceBackground(for: index))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                            }
                            .disabled(isShowingFeedback)
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 28)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingFeedback)
        .onAppear {
            score = 0; wrongQuizItems.removeAll()
            currentQuestionIndex = 0; isShowingFeedback = false; selectedIndex = nil
            if questions.isEmpty { questions = Array(allQuizItems.shuffled().prefix(5)) }
            totalQuestions = questions.count
            timeRemaining = timeLimit; timerRunning = true
        }
        .onDisappear { timerRunning = false }
        .onReceive(timer) { _ in
            guard timerRunning && !isShowingFeedback else { return }
            if timeRemaining > 0 { timeRemaining = max(0, timeRemaining - 0.1) }
            else { timerRunning = false; timeout() }
        }
    }

    // 選択肢の背景色
    func choiceBackground(for index: Int) -> Color {
        guard isShowingFeedback, let sel = selectedIndex else { return .appButton }
        if index == questions[currentQuestionIndex].correctAnswerIndex { return Color.appCorrect.opacity(0.18) }
        if index == sel { return Color.appWrong.opacity(0.18) }
        return .appButton
    }

    func answerTapped(_ index: Int) {
        selectedIndex = index; isShowingFeedback = true
        if index == questions[currentQuestionIndex].correctAnswerIndex {
            isCorrect = true; score += 1
        } else {
            isCorrect = false
            if !wrongQuizItems.contains(questions[currentQuestionIndex]) {
                wrongQuizItems.append(questions[currentQuestionIndex])
                dataManager.addWrongNote(
                    question: questions[currentQuestionIndex].question,
                    correctAnswer: questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex],
                    category: questions[currentQuestionIndex].category, mode: "choice"
                )
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isShowingFeedback = false; selectedIndex = nil; next()
        }
    }

    func timeout() {
        selectedIndex = nil; isCorrect = false; isShowingFeedback = true
        if !wrongQuizItems.contains(questions[currentQuestionIndex]) {
            wrongQuizItems.append(questions[currentQuestionIndex])
            dataManager.addWrongNote(
                question: questions[currentQuestionIndex].question,
                correctAnswer: questions[currentQuestionIndex].options[questions[currentQuestionIndex].correctAnswerIndex],
                category: questions[currentQuestionIndex].category, mode: "choice"
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isShowingFeedback = false; next()
        }
    }

    func next() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1; timeRemaining = timeLimit; timerRunning = true
        } else {
            let cats = Array(Set(questions.map { $0.category }))
            dataManager.saveHistory(score: score, total: questions.count, mode: "choice", categories: cats)
            currentScreen = .result
        }
    }
}
