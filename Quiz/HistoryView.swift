// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HistoryView.swift
// 学習履歴画面
// ・直近7回の正答率バーグラフ
// ・分野別 苦手ランキング
// ・プレイ履歴一覧
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import SwiftUI

struct HistoryView: View {

    @Binding var currentScreen: Screen
    @EnvironmentObject var dataManager: DataManager

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
                    Text("📊 学習履歴")
                        .font(.headline).fontWeight(.bold).foregroundStyle(Color.appPrimary)
                    Spacer()
                    Color.clear.frame(width: 28)
                }
                .padding(.horizontal, 20).padding(.top, 20).padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 20) {

                        // ── 直近7回グラフ ──
                        if !dataManager.recentScores.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("直近の正答率")
                                    .font(.subheadline).fontWeight(.bold)
                                    .foregroundStyle(Color.appPrimary)

                                HStack(alignment: .bottom, spacing: 8) {
                                    ForEach(Array(dataManager.recentScores.enumerated()), id: \.offset) { _, val in
                                        VStack(spacing: 4) {
                                            Text("\(Int(val * 100))%")
                                                .font(.system(size: 10))
                                                .foregroundStyle(Color.appPrimary.opacity(0.6))
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(barColor(val))
                                                .frame(width: 32, height: max(8, CGFloat(val) * 100))
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(height: 120, alignment: .bottom)
                            }
                            .padding(16)
                            .background(Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }

                        // ── 分野別 苦手ランキング ──
                        let byCategory = Dictionary(grouping: dataManager.wrongNotes, by: { $0.category })
                        if !byCategory.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("🎯 分野別 苦手ランキング")
                                    .font(.subheadline).fontWeight(.bold)
                                    .foregroundStyle(Color.appPrimary)

                                let sorted = byCategory.sorted {
                                    $0.value.reduce(0) { $0 + $1.missCount } >
                                    $1.value.reduce(0) { $0 + $1.missCount }
                                }
                                let maxMiss = sorted.first.map {
                                    $0.value.reduce(0) { $0 + $1.missCount }
                                } ?? 1

                                ForEach(sorted, id: \.key) { cat, notes in
                                    let miss = notes.reduce(0) { $0 + $1.missCount }
                                    HStack(spacing: 10) {
                                        Text(cat)
                                            .font(.subheadline).foregroundStyle(Color.appPrimary)
                                            .frame(width: 110, alignment: .leading)
                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.white.opacity(0.5)).frame(height: 14)
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.appWrong.opacity(0.65))
                                                    .frame(
                                                        width: geo.size.width * CGFloat(miss) / CGFloat(maxMiss),
                                                        height: 14
                                                    )
                                            }
                                        }
                                        .frame(height: 14)
                                        Text("\(miss)回")
                                            .font(.caption).fontWeight(.semibold)
                                            .foregroundStyle(Color.appWrong)
                                            .frame(width: 36, alignment: .trailing)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 20)
                        }

                        // ── 履歴一覧 ──
                        if !dataManager.histories.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("プレイ履歴")
                                    .font(.subheadline).fontWeight(.bold)
                                    .foregroundStyle(Color.appPrimary)

                                ForEach(dataManager.histories) { h in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(h.mode == "choice" ? "選択式" : "入力式")
                                                .font(.caption).fontWeight(.semibold)
                                                .foregroundStyle(Color.appAccent)
                                            Text(dateString(h.date))
                                                .font(.caption2).foregroundStyle(Color.appPrimary.opacity(0.5))
                                        }
                                        Spacer()
                                        Text("\(h.score)/\(h.total)問")
                                            .font(.subheadline).fontWeight(.semibold)
                                            .foregroundStyle(Color.appPrimary)
                                        Text("\(Int(h.percent * 100))%")
                                            .font(.subheadline).fontWeight(.bold)
                                            .foregroundStyle(barColor(h.percent))
                                            .frame(width: 48, alignment: .trailing)
                                    }
                                    .padding(12)
                                    .background(Color.appCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            Text("まだ履歴がないクマ🐻\nクイズを解いてみよう！")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.appPrimary.opacity(0.5))
                                .padding(40)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.top, 4)
                }
            }
        }
    }

    func barColor(_ val: Double) -> Color {
        val >= 0.8 ? .appCorrect : val >= 0.5 ? .appTimerWarn : .appWrong
    }

    func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateStyle = .short; f.timeStyle = .short
        return f.string(from: date)
    }
}
