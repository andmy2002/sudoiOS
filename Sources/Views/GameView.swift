import SwiftUI

struct GameView: View {
    @StateObject private var game: SudokuGame
    @EnvironmentObject var gameProgress: GameProgress
    @EnvironmentObject var settings: SudokuGameSettings
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCell: (row: Int, col: Int)? = nil
    @State private var showingCompletionAlert = false
    let level: Int
    
    init(difficulty: Difficulty, level: Int, settings: SudokuGameSettings) {
        self.level = level
        _game = StateObject(wrappedValue: SudokuGame(difficulty: difficulty, settings: settings))
    }
    
    var body: some View {
        VStack {
            // 显示当前关卡和时间
            HStack {
                Text("第\(level)关")
                    .font(.headline)
                    .foregroundColor(settings.theme.textColor)
                Spacer()
                Text(String(format: "用时: %.0f秒", game.timeElapsed))
                    .font(.headline)
                    .foregroundColor(settings.theme.textColor)
            }
            .padding()
            
            // 数独棋盘
            SudokuBoard(game: game, selectedCell: $selectedCell)
                .padding()
            
            // 数字输入键盘
            if let cell = selectedCell {
                HStack {
                    NumberPad { number in
                        game.setNumber(number, at: cell.row, col: cell.col)
                    }
                    
                    // 提示按钮
                    Button(action: {
                        if let hint = game.getHint(at: cell.row, col: cell.col) {
                            game.setNumber(hint, at: cell.row, col: cell.col)
                        }
                    }) {
                        Image(systemName: "lightbulb.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                    .padding(.leading)
                }
                .padding()
            }
        }
        .navigationBarTitle("数独", displayMode: .inline)
        .background(settings.theme.backgroundColor)
        .alert(isPresented: $showingCompletionAlert) {
            Alert(
                title: Text("恭喜!"),
                message: Text("你完成了这一关!\n用时: \(Int(game.timeElapsed))秒"),
                primaryButton: .default(Text("下一关")) {
                    // 更新最佳时间
                    gameProgress.updateBestTime(for: game.difficulty, level: level, time: game.timeElapsed)
                    // 解锁下一关
                    gameProgress.unlockNextLevel(for: game.difficulty)
                    // 返回关卡选择界面
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("返回")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onChange(of: game.isComplete) { completed in
            if completed {
                showingCompletionAlert = true
            }
        }
    }
}

struct SudokuBoard: View {
    @ObservedObject var game: SudokuGame
    @Binding var selectedCell: (row: Int, col: Int)?
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<9) { row in
                HStack(spacing: 1) {
                    ForEach(0..<9) { col in
                        CellView(
                            number: game.grid[row][col],
                            isSelected: selectedCell?.row == row && selectedCell?.col == col,
                            isInitial: game.isInitialNumber(at: row, col: col),
                            hasError: game.errorCells.contains("\(row),\(col)")
                        )
                        .onTapGesture {
                            selectedCell = (row, col)
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
}

struct CellView: View {
    let number: Int?
    let isSelected: Bool
    let isInitial: Bool
    let hasError: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .frame(width: 35, height: 35)
            
            if let number = number {
                Text("\(number)")
                    .font(.title2)
                    .foregroundColor(textColor)
            }
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue.opacity(0.3)
        } else if hasError {
            return .red.opacity(0.2)
        } else {
            return .white
        }
    }
    
    private var textColor: Color {
        if hasError {
            return .red
        } else if isInitial {
            return .black
        } else {
            return .blue
        }
    }
}

struct NumberPad: View {
    let onNumberSelected: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            // 第一行：1-3
            HStack(spacing: 10) {
                ForEach(1...3, id: \.self) { number in
                    Button(action: { onNumberSelected(number) }) {
                        Text("\(number)")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            
            // 第二行：4-6
            HStack(spacing: 10) {
                ForEach(4...6, id: \.self) { number in
                    Button(action: { onNumberSelected(number) }) {
                        Text("\(number)")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            
            // 第三行：7-9
            HStack(spacing: 10) {
                ForEach(7...9, id: \.self) { number in
                    Button(action: { onNumberSelected(number) }) {
                        Text("\(number)")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            
            // 第四行：清除按钮
            HStack {
                Button(action: { onNumberSelected(0) }) {
                    Image(systemName: "delete.left")
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = SudokuGameSettings()
        NavigationView {
            GameView(difficulty: .easy, level: 1, settings: settings)
                .environmentObject(GameProgress())
                .environmentObject(settings)
        }
    }
} 