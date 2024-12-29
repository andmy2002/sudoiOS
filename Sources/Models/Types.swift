import Foundation
import SwiftUI

// Common type definitions
public protocol SudokuGameProtocol {
    var board: [[Int]] { get set }
    var solution: [[Int]] { get set }
    var initialBoard: [[Int]] { get }
    var selectedCell: (row: Int, col: Int)? { get set }
    
    func isValid(number: Int, at row: Int, col: Int) -> Bool
    func setNumber(_ number: Int, at row: Int, col: Int)
    func isComplete() -> Bool
    func isInitialNumber(at row: Int, col: Int) -> Bool
}

public protocol GameProgressProtocol {
    var unlockedLevels: [Difficulty: Int] { get set }
    var bestTimes: [String: TimeInterval] { get set }
    
    func isLevelUnlocked(difficulty: Difficulty, level: Int) -> Bool
    func unlockNextLevel(for difficulty: Difficulty)
    func getBestTime(for difficulty: Difficulty, level: Int) -> TimeInterval?
    func setBestTime(_ time: TimeInterval, for difficulty: Difficulty, level: Int)
}

public enum Difficulty: String, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    public var displayName: String {
        switch self {
        case .easy: return "简单"
        case .medium: return "中等"
        case .hard: return "困难"
        }
    }
    
    public var maxLevels: Int {
        switch self {
        case .easy: return 100
        case .medium: return 80
        case .hard: return 50
        }
    }
    
    public var initialNumbers: Int {
        switch self {
        case .easy: return 45
        case .medium: return 35
        case .hard: return 25
        }
    }
} 