import SwiftUI

struct ContentView: View {
    @StateObject private var gameProgress = GameProgress()
    @StateObject private var settings = SudokuGameSettings()
    
    var body: some View {
        NavigationView {
            ZStack {
                settings.theme.backgroundColor.ignoresSafeArea()
                
                VStack {
                    Text("数独游戏")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(settings.theme.textColor)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        NavigationLink {
                            LevelSelectView()
                        } label: {
                            MenuButton(title: "开始游戏", color: .blue)
                        }
                        
                        NavigationLink {
                            SettingsView()
                        } label: {
                            MenuButton(title: "设置", color: .orange)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(gameProgress)
        .environmentObject(settings)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetGameProgress"))) { _ in
            gameProgress.reset()
        }
    }
}

private struct MenuButton: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(color)
            .cornerRadius(10)
    }
}

#Preview {
    ContentView()
} 