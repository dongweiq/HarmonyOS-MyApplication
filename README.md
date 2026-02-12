# 🎮 坦克大战 - HarmonyOS 版

基于 HarmonyOS (ArkTS) 开发的经典坦克大战游戏。

## 📱 项目截图

```
┌─────────────────┐
│    坦克大战      │
│       🎮        │
│   最高分: 0     │
│   [开始游戏]    │
│                 │
│   操作说明:     │
│  ↑↓←→: 移动    │
│  🔥: 发射子弹   │
└─────────────────┘
```

## ✨ 游戏特性

- 🕹️ 经典坦克大战玩法
- 🎯 方向键控制坦克移动
- 💥 发射子弹消灭敌人
- 🧱 可破坏的墙壁障碍
- 🤖 敌方 AI 自动移动和射击
- 🏆 计分系统

## 🛠️ 技术栈

- **平台**: HarmonyOS 4.0+
- **语言**: ArkTS (TypeScript)
- **框架**: ArkUI
- **IDE**: DevEco Studio 4.0+

## 📁 项目结构

```
MyApplication/
├── AppScope/                    # 应用级配置
│   └── app.json5               # 应用配置文件
├── entry/                       # 主模块
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/   # 入口 Ability
│       │   ├── model/
│       │   │   └── GameModel.ets    # 游戏数据模型
│       │   └── pages/
│       │       ├── Index.ets        # 主页
│       │       └── GamePage.ets     # 游戏页面
│       ├── resources/          # 资源文件
│       └── module.json5        # 模块配置
├── build-profile.json5         # 构建配置
└── oh-package.json5            # 依赖配置
```

## 🎮 游戏玩法

### 操作说明
| 按钮 | 功能 |
|------|------|
| ⬆️ | 向上移动 |
| ⬇️ | 向下移动 |
| ⬅️ | 向左移动 |
| ➡️ | 向右移动 |
| 🔥 | 发射子弹 |

### 游戏规则
1. 消灭所有敌方坦克（红色）获得胜利
2. 被敌方子弹击中则游戏结束
3. 每消灭一个敌人获得 100 分
4. 棕色墙壁可被子弹摧毁

## 🚀 快速开始

### 环境要求
- DevEco Studio 4.0 或更高版本
- HarmonyOS SDK API 9+
- 鸿蒙设备或模拟器

### 运行步骤
1. 使用 DevEco Studio 打开项目
2. 配置签名（如需真机调试）
3. 选择设备/模拟器
4. 点击运行按钮

## 📝 核心代码

### 游戏模型 (GameModel.ets)
```typescript
// 方向枚举
export enum Direction {
  UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3
}

// 坦克类
export class Tank {
  x: number = 0;
  y: number = 0;
  direction: Direction = Direction.UP;
  speed: number = 5;
  isPlayer: boolean = true;
  isAlive: boolean = true;
}

// 子弹类
export class Bullet {
  x: number = 0;
  y: number = 0;
  direction: Direction = Direction.UP;
  speed: number = 10;
}
```

## 📄 License

MIT License

---

**开发时间**: 2026年2月  
**开发环境**: DevEco Studio 4.0 + HarmonyOS 4.0
