import AudioToolbox
import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private init() {
        // 无需初始化
    }
    
    func playTapSound() {
        AudioServicesPlaySystemSound(1104) // 标准的点击音效
    }
    
    func playCompleteSound() {
        AudioServicesPlaySystemSound(1001) // 完成音效
    }
    
    func playErrorSound() {
        AudioServicesPlaySystemSound(1053) // 错误音效
    }
} 