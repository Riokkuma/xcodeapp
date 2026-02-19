// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ContentView.swift
// 画面切り替えの司令塔
// どの画面を表示するかここで管理する
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct ContentView: View {

    // DataManagerを全画面で共有
    @StateObject private var dataManager = DataManager.shared

    // 現在の画面
    @State private var currentScreen: Screen = .start

    // スコア・問題数
    @State private var score          = 0
    @State private var totalQuestions = 0

    // 間違えた問題
    @State private var wrongQuizItems:      [QuizItem]      = []
    @State private var wrongInputQuizItems: [InputQuizItem] = []

    // モード管理
    @State private var lastMode:  QuizMode = .choice
    @State private var playMode:  PlayMode = .normal

    // 出題する問題（通常 or 復習）
    @State private var choiceQuestions: [QuizItem]      = []
    @State private var inputQuestions:  [InputQuizItem] = []

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            switch currentScreen {

            case .start:
                StartView(currentScreen: $currentScreen, lastMode: $lastMode)
                    .onAppear {
                        playMode = .normal
                        choiceQuestions.removeAll()
                        inputQuestions.removeAll()
                    }

            case .quiz:
                QuizView(
                    currentScreen:  $currentScreen,
                    score:          $score,
                    totalQuestions: $totalQuestions,
                    wrongQuizItems: $wrongQuizItems,
                    questions:      $choiceQuestions
                )

            case .input:
                InputQuizView(
                    currentScreen:       $currentScreen,
                    score:               $score,
                    totalQuestions:      $totalQuestions,
                    wrongInputQuizItems: $wrongInputQuizItems,
                    questions:           $inputQuestions
                )

            case .result:
                ResultView(
                    currentScreen:       $currentScreen,
                    score:               $score,
                    totalQuestions:      totalQuestions,
                    wrongQuizItems:      wrongQuizItems,
                    wrongInputQuizItems: wrongInputQuizItems,
                    lastMode:            lastMode,
                    playMode:            $playMode,
                    choiceQuestions:     $choiceQuestions,
                    inputQuestions:      $inputQuestions
                )

            case .history:
                HistoryView(currentScreen: $currentScreen)

            case .wrongNote:
                WrongNoteView(currentScreen: $currentScreen)
            }
        }
        .environmentObject(dataManager)
    }
}

#Preview {
    ContentView()
}
