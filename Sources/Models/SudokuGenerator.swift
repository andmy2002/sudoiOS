import Foundation

class SudokuGenerator {
    private var board: [[Int]]
    
    init() {
        self.board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    }
    
    // 生成完整的数独解决方案
    func generateSolution() -> [[Int]] {
        // 清空棋盘
        board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        // 从第一个位置开始填充
        _ = fillBoard(row: 0, col: 0)
        return board
    }
    
    // 生成带空格的数独题目
    func generatePuzzle(difficulty: Difficulty) -> ([[Int?]], [[Int]]) {
        // 先生成完整解决方案
        let solution = generateSolution()
        
        // 根据难度决定要挖多少个空
        let holesCount: Int
        switch difficulty {
        case .easy:
            holesCount = 30  // 留下51个数字
        case .medium:
            holesCount = 40  // 留下41个数字
        case .hard:
            holesCount = 50  // 留下31个数字
        }
        
        // 复制解决方案
        var puzzle = solution.map { $0.map { Int?($0) } }
        
        // 随机挖空
        var holes = 0
        while holes < holesCount {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if puzzle[row][col] != nil {
                puzzle[row][col] = nil
                holes += 1
            }
        }
        
        return (puzzle, solution)
    }
    
    // 递归填充数独板
    private func fillBoard(row: Int, col: Int) -> Bool {
        // 如果已经填充完所有格子，返回true
        if row == 9 {
            return true
        }
        
        // 计算下一个位置
        let nextRow = col == 8 ? row + 1 : row
        let nextCol = col == 8 ? 0 : col + 1
        
        // 如果当前格子已经有数字，继续下一个
        if board[row][col] != 0 {
            return fillBoard(row: nextRow, col: nextCol)
        }
        
        // 随机尝试1-9的数字
        let numbers = Array(1...9).shuffled()
        for number in numbers {
            if isValid(number: number, row: row, col: col) {
                board[row][col] = number
                
                if fillBoard(row: nextRow, col: nextCol) {
                    return true
                }
                
                board[row][col] = 0
            }
        }
        
        return false
    }
    
    // 检查在指定位置放置数字是否有效
    private func isValid(number: Int, row: Int, col: Int) -> Bool {
        // 检查行
        for i in 0..<9 {
            if board[row][i] == number {
                return false
            }
        }
        
        // 检查列
        for i in 0..<9 {
            if board[i][col] == number {
                return false
            }
        }
        
        // 检查3x3方格
        let boxRow = row - row % 3
        let boxCol = col - col % 3
        for i in 0..<3 {
            for j in 0..<3 {
                if board[boxRow + i][boxCol + j] == number {
                    return false
                }
            }
        }
        
        return true
    }
} 