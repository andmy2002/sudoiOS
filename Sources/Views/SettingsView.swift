import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SudokuGameSettings
    @Environment(\.dismiss) var dismiss
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            settings.theme.backgroundColor.ignoresSafeArea()
            
            Form {
                Section(header: Text("游戏设置")) {
                    Toggle("音效", isOn: $settings.soundEnabled)
                    Toggle("振动", isOn: $settings.vibrationEnabled)
                }
                
                Section(header: Text("主题")) {
                    Picker("主题", selection: $settings.theme) {
                        ForEach(GameTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("重置游戏进度")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("完成") {
            settings.save()
            dismiss()
        })
        .alert("确认重置", isPresented: $showingResetAlert) {
            Button("取消", role: .cancel) { }
            Button("重置", role: .destructive) {
                resetGameProgress()
            }
        } message: {
            Text("这将清除所有游戏进度，包括已解锁的关卡和最佳记录。此操作无法撤销。")
        }
    }
    
    private func resetGameProgress() {
        UserDefaults.standard.removeObject(forKey: "unlockedLevels")
        UserDefaults.standard.removeObject(forKey: "bestTimes")
        NotificationCenter.default.post(name: NSNotification.Name("ResetGameProgress"), object: nil)
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(SudokuGameSettings())
    }
} 