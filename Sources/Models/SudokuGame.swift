import Foundation

public class SudokuGame: ObservableObject {
    @Published public var grid: [[Int?]]
    @Published public var solution: [[Int]]
    @Published public var isComplete: Bool = false
    @Published public var timeElapsed: TimeInterval = 0
    @Published public var errorCells: Set<String> = []
    @Published public var currentLevel: Int = 1
    @Published public var totalTime: TimeInterval = 0
    
    private var initialGrid: [[Int?]]
    private var moveHistory: [(row: Int, col: Int, value: Int?)] = []
    private var timer: Timer?
    public let difficulty: Difficulty
    private let generator: SudokuGenerator
    private let settings: SudokuGameSettings
    
    public init(difficulty: Difficulty, settings: SudokuGameSettings) {
        self.difficulty = difficulty
        self.settings = settings
        self.generator = SudokuGenerator()
        
        // 初始化数组
        self.grid = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        self.solution = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.initialGrid = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        
        // 生成新游戏
        let (puzzle, completeSolution) = self.generator.generatePuzzle(difficulty: difficulty)
        self.grid = puzzle
        self.solution = completeSolution
        self.initialGrid = puzzle
        
        // 启动计时器
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // 进入下一关
    func nextLevel() {
        currentLevel += 1
        totalTime += timeElapsed
        generateNewGame()
    }
    
    func generateNewGame() {
        let (puzzle, completeSolution) = generator.generatePuzzle(difficulty: difficulty)
        self.grid = puzzle
        self.solution = completeSolution
        self.initialGrid = puzzle
        self.isComplete = false
        self.timeElapsed = 0
        self.errorCells.removeAll()
        self.moveHistory.removeAll()
        startTimer()  // 重新开始计时
    }
    
    func setNumber(_ number: Int, at row: Int, col: Int) {
        // 如果是初始数字，不允许修改
        if isInitialNumber(at: row, col: col) {
            if settings.soundEnabled {
                SoundManager.shared.playErrorSound()
            }
            return
        }
        
        // 保存当前状态用于撤销
        moveHistory.append((row: row, col: col, value: grid[row][col]))
        
        // 如果是清除操作（number = 0）
        if number == 0 {
            grid[row][col] = nil
            checkErrors()
            if settings.soundEnabled {
                SoundManager.shared.playTapSound()
            }
            return
        }
        
        // 检查数字范围是否有效
        guard number >= 1 && number <= 9 else {
            return
        }
        
        // 填入数字
        grid[row][col] = number
        
        // 检查错误并播放音效
        checkErrors()
        if settings.soundEnabled {
            if errorCells.contains("\(row),\(col)") {
                SoundManager.shared.playErrorSound()
            } else {
                SoundManager.shared.playTapSound()
            }
        }
        
        // 检查是否完成
        checkCompletion()
    }
    
    // 撤销上一步操作
    func undo() {
        guard let lastMove = moveHistory.popLast() else { return }
        grid[lastMove.row][lastMove.col] = lastMove.value
        checkErrors()
    }
    
    // 获取提示
    func getHint(at row: Int, col: Int) -> Int? {
        // 如果是初始数字，返回nil
        if isInitialNumber(at: row, col: col) {
            return nil
        }
        
        // 如果当前数字是错误的，或者格子是空的，返回正确答案
        if grid[row][col] == nil || errorCells.contains("\(row),\(col)") {
            return solution[row][col]
        }
        
        return nil
    }
    
    // 检查错误
    private func checkErrors() {
        errorCells.removeAll()
        
        for row in 0..<9 {
            for col in 0..<9 {
                if let number = grid[row][col] {
                    // 检查是否与解决方案不符
                    if number != solution[row][col] {
                        errorCells.insert("\(row),\(col)")
                    }
                }
            }
        }
    }
    
    func isValid(number: Int, at row: Int, col: Int) -> Bool {
        // 检查行
        for i in 0..<9 {
            if i != col && grid[row][i] == number {
                return false
            }
        }
        
        // 检查列
        for i in 0..<9 {
            if i != row && grid[i][col] == number {
                return false
            }
        }
        
        // 检查3x3方格
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        
        for i in boxRow..<(boxRow + 3) {
            for j in boxCol..<(boxCol + 3) {
                if (i != row || j != col) && grid[i][j] == number {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func checkCompletion() {
        // 检查是否所有格子都已填满且没有错误
        if errorCells.isEmpty {
            for row in 0..<9 {
                for col in 0..<9 {
                    if grid[row][col] == nil {
                        return
                    }
                }
            }
            // 如果执行到这里，说明游戏完成
            isComplete = true
            stopTimer()
            
            // 播放完成音效
            if settings.soundEnabled {
                SoundManager.shared.playCompleteSound()
            }
        }
    }
    
    private func startTimer() {
        stopTimer()  // 先停止可能存在的计时器
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.timeElapsed += 1
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 添加公共方法来检查是否是初始数字
    func isInitialNumber(at row: Int, col: Int) -> Bool {
        return initialGrid[row][col] != nil
    }
} 
