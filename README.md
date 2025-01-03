# iOS 数独游戏

一个优雅的iOS数独游戏，使用SwiftUI开发，提供流畅的游戏体验和精美的界面设计。

## 功能特点

### 游戏玩法
- 三种难度等级：简单(50关)、中等(30关)、困难(20关)
- 每个难度的第一关都默认解锁，玩家可以自由选择开始难度
- 通过完成当前关卡来解锁后续关卡
- 实时计时系统，记录每关完成时间
- 最佳时间记录保存功能

### 游戏界面
- 现代简约的界面设计
- 清晰的数字输入界面
- 错误提示功能
- 实时进度显示
- 关卡选择界面
- 设置界面

### 游戏特性
- 音效反馈系统
  - 数字输入音效
  - 错误提示音效
  - 完成关卡音效
- 进度保存功能
- 撤销功能
- 提示功能

### 设置选项
- 声音开关
- 震动开关
- 主题选择
- 重置游戏进度

## 技术细节

### 开发环境
- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

### 框架使用
- SwiftUI：用于构建用户界面
- Combine：用于状态管理
- UserDefaults：用于数据持久化
- AudioToolbox：用于音效系统

### 项目结构
```
Sources/
├── Models/          # 数据模型
│   ├── SudokuGame.swift
│   ├── GameProgress.swift
│   ├── Types.swift
│   └── Settings.swift
├── Views/           # 视图组件
│   ├── ContentView.swift
│   ├── GameView.swift
│   ├── LevelSelectView.swift
│   └── SettingsView.swift
└── Utils/          # 工具类
    └── SoundManager.swift
```

## 安装说明

1. 克隆项目
```bash
git clone https://github.com/andmy2002/sudoiOS.git
```

2. 打开项目
```bash
cd sudoiOS
xed .
```

3. 运行项目
- 在Xcode中选择目标设备（iOS 15.0+）
- 点击运行按钮或按下 `Cmd + R`

## 游戏玩法说明

1. 开始游戏
   - 从主界面选择难度等级
   - 选择想要挑战的关卡
   - 点击开始游戏

2. 游戏操作
   - 点击空白格子
   - 从数字面板选择1-9的数字
   - 使用撤销按钮可以撤销上一步操作
   - 使用提示功能可以获取当前格子的正确数字

3. 完成关卡
   - 正确填完所有空格即可完成关卡
   - 系统会记录完成时间
   - 如果创造了最佳记录，会被保存下来

## 开发计划

- [ ] 添加更多主题选项
- [ ] 实现在线排行榜
- [ ] 添加成就系统
- [ ] 支持自定义难度
- [ ] 添加分享功能

## 贡献指南

欢迎提交 Issue 和 Pull Request 来帮助改进游戏。在提交PR之前，请确保：

1. 代码符合项目的代码规范
2. 添加了必要的测试
3. 更新了相关文档

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。 