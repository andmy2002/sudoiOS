import SwiftUI

@main
struct SudokuGameApp: App {
    @StateObject private var gameProgress = GameProgress()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameProgress)
        }
    }
} 