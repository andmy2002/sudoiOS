import SwiftUI

public class SudokuGameSettings: ObservableObject {
    @Published public var soundEnabled: Bool = false
    @Published public var vibrationEnabled: Bool = false
    @Published public var theme: GameTheme = .classic
    
    public init() {
        self.soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        self.vibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        if let savedTheme = UserDefaults.standard.string(forKey: "theme"),
           let theme = GameTheme(rawValue: savedTheme) {
            self.theme = theme
        }
    }
    
    public func save() {
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
        UserDefaults.standard.set(theme.rawValue, forKey: "theme")
    }
}

public enum GameTheme: String, CaseIterable {
    case classic = "classic"
    case dark = "dark"
    case light = "light"
    
    public var displayName: String {
        switch self {
        case .classic: return "经典"
        case .dark: return "深色"
        case .light: return "浅色"
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .classic: return .white
        case .dark: return Color(.systemGray6)
        case .light: return Color(.systemGray6)
        }
    }
    
    public var textColor: Color {
        switch self {
        case .classic: return .black
        case .dark: return .white
        case .light: return .black
        }
    }
} 