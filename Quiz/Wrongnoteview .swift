// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// WrongNoteView.swift
// 間違いノート画面
// ・カテゴリフィルター
// ・ミス回数順で表示
// ・全削除機能
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct WrongNoteView: View {

    @Binding var currentScreen: Screen
    @EnvironmentObject var dataManager: DataManager
    @State private var showClearAlert   = false
    @State private var selectedCategory = "すべて"

    var categories: [String] {
        ["すべて"] + Array(Set(dataManager.wrongNotes.map { $0.category })).sorted()
    }

    var filteredNotes: [WrongNote] {
        selectedCategory == "すべて"
            ? dataManager.wrongNotes
            : dataManager.wrongNotes.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── ヘッダー ──
                HStack {
                    Button { currentScreen = .start } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3).fontWeight(.semibold)
                            .foregroundStyle(Color.appPrimary)
                    }
                    Spacer()
                    Text("📝 間違いノート")
                        .font(.headline).fontWeight(.bold).foregroundStyle(Color.appPrimary)
                    Spacer()
                    if !dataManager.wrongNotes.isEmpty {
                        Button { showClearAlert = true } label: {
                            Image(systemName: "trash")
                                .font(.body).foregroundStyle(Color.appWrong)
                        }
                    } else {
                        Color.clear.frame(width: 28)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 12)

                if dataManager.wrongNotes.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("🎉").font(.system(size: 60))
                        Text("間違いノートは空クマ！\n全問正解してるよ！すごい！🐻✨")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.appPrimary.opacity(0.6))
                    }
                    Spacer()
                } else {
                    // ── カテゴリフィルター ──
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                Button {
                                    selectedCategory = cat
                                } label: {
                                    Text(cat)
                                        .font(.caption).fontWeight(.semibold)
                                        .padding(.horizontal, 14).padding(.vertical, 7)
                                        .background(
                                            selectedCategory == cat ? Color.appAccent : Color.appCard
                                        )
                                        .foregroundStyle(
                                            selectedCategory == cat ? Color.white : Color.appPrimary
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 12)

                    // ── ノート一覧 ──
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(filteredNotes.sorted { $0.missCount > $1.missCount }) { note in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(note.category)
                                            .font(.caption2).fontWeight(.semibold)
                                            .foregroundStyle(Color.appAccent)
                                            .padding(.horizontal, 8).padding(.vertical, 3)
                                            .background(Color.appAccent.opacity(0.12))
                                            .clipShape(Capsule())
                                        Spacer()
                                        Text("ミス \(note.missCount)回")
                                            .font(.caption).fontWeight(.bold)
                                            .foregroundStyle(note.missCount >= 3 ? Color.appWrong : Color.appTimerWarn)
                                    }
                                    Text("Q. \(note.question)")
                                        .font(.subheadline).fontWeight(.semibold)
                                        .foregroundStyle(Color.appPrimary)
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.appCorrect)
                                        Text(note.correctAnswer)
                                            .font(.subheadline).foregroundStyle(Color.appPrimary.opacity(0.8))
                                    }
                                }
                                .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.appCard)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 20).padding(.bottom, 30)
                    }
                }
            }
        }
        .alert("間違いノートをリセットする？", isPresented: $showClearAlert) {
            Button("リセット", role: .destructive) { dataManager.clearWrongNotes() }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全ての間違いノートが削除されるクマ🐻")
        }
    }
}
