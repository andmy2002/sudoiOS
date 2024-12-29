import SwiftUI
import Foundation

@_exported import struct Foundation.TimeInterval

struct LevelSelectView: View {
    @EnvironmentObject var gameProgress: GameProgress
    @EnvironmentObject var settings: SudokuGameSettings
    @State private var selectedDifficulty: Difficulty = .easy
    
    var body: some View {
        ZStack {
            settings.theme.backgroundColor.ignoresSafeArea()
            
            VStack {
                Picker("难度", selection: $selectedDifficulty) {
                    ForEach([Difficulty.easy, .medium, .hard], id: \.self) { difficulty in
                        Text(difficulty.displayName).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                        ForEach(1...selectedDifficulty.maxLevels, id: \.self) { level in
                            NavigationLink {
                                GameView(difficulty: selectedDifficulty, level: level, settings: settings)
                            } label: {
                                LevelButtonContent(
                                    level: level,
                                    isUnlocked: gameProgress.isLevelUnlocked(difficulty: selectedDifficulty, level: level),
                                    bestTime: gameProgress.getBestTime(for: selectedDifficulty, level: level)
                                )
                            }
                            .disabled(!gameProgress.isLevelUnlocked(difficulty: selectedDifficulty, level: level))
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("选择关卡")
    }
}

struct LevelButtonContent: View {
    let level: Int
    let isUnlocked: Bool
    let bestTime: TimeInterval?
    
    var body: some View {
        VStack {
            Text("第\(level)关")
                .font(.headline)
            if let time = bestTime {
                Text(String(format: "%.0f秒", time))
                    .font(.caption)
            }
        }
        .frame(width: 80, height: 80)
        .background(isUnlocked ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
        .opacity(isUnlocked ? 1.0 : 0.5)
    }
}

struct LevelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = SudokuGameSettings()
        let gameProgress = GameProgress()
        NavigationView {
            LevelSelectView()
                .environmentObject(gameProgress)
                .environmentObject(settings)
        }
    }
} 