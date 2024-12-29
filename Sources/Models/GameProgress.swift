import Foundation
@_exported import struct Foundation.TimeInterval

public class GameProgress: ObservableObject {
    @Published public var unlockedLevels: [Difficulty: Int]
    @Published public var bestTimes: [Difficulty: [Int: TimeInterval]]
    
    private let defaults = UserDefaults.standard
    private let unlockedLevelsKey = "unlockedLevels"
    private let bestTimesKey = "bestTimes"
    
    public init() {
        self.unlockedLevels = [
            .easy: 1,
            .medium: 1,
            .hard: 1
        ]
        
        self.bestTimes = [
            .easy: [:],
            .medium: [:],
            .hard: [:]
        ]
        
        loadProgress()
    }
    
    public func unlockNextLevel(for difficulty: Difficulty) {
        if let current = unlockedLevels[difficulty] {
            unlockedLevels[difficulty] = current + 1
            saveProgress()
        }
    }
    
    public func isLevelUnlocked(difficulty: Difficulty, level: Int) -> Bool {
        return unlockedLevels[difficulty] ?? 0 >= level
    }
    
    public func updateBestTime(for difficulty: Difficulty, level: Int, time: TimeInterval) {
        if let currentBest = bestTimes[difficulty]?[level] {
            if time < currentBest {
                bestTimes[difficulty]?[level] = time
                saveProgress()
            }
        } else {
            if bestTimes[difficulty] == nil {
                bestTimes[difficulty] = [:]
            }
            bestTimes[difficulty]?[level] = time
            saveProgress()
        }
    }
    
    public func getBestTime(for difficulty: Difficulty, level: Int) -> TimeInterval? {
        return bestTimes[difficulty]?[level]
    }
    
    private func saveProgress() {
        let unlockedData = unlockedLevels.mapValues { $0 }
        defaults.set(unlockedData, forKey: unlockedLevelsKey)
        
        let bestTimesData = bestTimes.mapValues { $0.mapValues { $0 } }
        defaults.set(bestTimesData, forKey: bestTimesKey)
    }
    
    private func loadProgress() {
        if let unlockedData = defaults.object(forKey: unlockedLevelsKey) as? [String: Int] {
            unlockedLevels = Dictionary(uniqueKeysWithValues: unlockedData.compactMap { key, value in
                guard let difficulty = Difficulty(rawValue: key) else { return nil }
                return (difficulty, value)
            })
        }
        
        if let bestTimesData = defaults.object(forKey: bestTimesKey) as? [String: [String: TimeInterval]] {
            for (diffKey, levelTimes) in bestTimesData {
                if let difficulty = Difficulty(rawValue: diffKey) {
                    let convertedTimes = Dictionary<Int, TimeInterval>(uniqueKeysWithValues: levelTimes.compactMap { levelKey, time in
                        guard let level = Int(levelKey) else { return nil }
                        return (level, time)
                    })
                    bestTimes[difficulty] = convertedTimes
                }
            }
        }
    }
    
    public func reset() {
        unlockedLevels = [
            .easy: 1,
            .medium: 1,
            .hard: 1
        ]
        bestTimes = [
            .easy: [:],
            .medium: [:],
            .hard: [:]
        ]
        saveProgress()
    }
} 
