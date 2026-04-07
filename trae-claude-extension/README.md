# Claude Code for Trae IDE

将 Claude Code 集成到 Trae IDE 中的 VS Code 扩展。

## 功能特性

- 🚀 直接在 Trae IDE 中启动 Claude Code 终端
- 🔑 API 密钥配置和管理
- 📦 自动安装 Claude Code CLI
- 💬 集成式聊天体验
- 🛠️ 完整的代码编辑和执行能力
- 🎨 侧边栏聊天面板
- ⌨️ 快捷键支持 (Ctrl+Shift+C)

## 安装

### 从 VSIX 安装

1. 下载最新的 `.vsix` 文件
2. 在 Trae IDE 中打开命令面板 (Ctrl+Shift+P)
3. 输入 "Extensions: Install from VSIX..."
4. 选择下载的 `.vsix` 文件

### 从源码构建

```bash
git clone <repository-url>
cd trae-claude-extension
npm install
npm run compile
```

然后在 Trae IDE 中：
1. 按 F5 启动扩展开发主机
2. 在新窗口中测试扩展

## 使用方法

### 配置 API 密钥

1. 打开 Trae IDE 设置 (Ctrl+,)
2. 搜索 "Claude Code"
3. 输入你的 Anthropic API 密钥

### 启动 Claude

1. 打开命令面板 (Ctrl+Shift+P)
2. 输入 "Claude: Open Claude Terminal"
3. 在终端中与 Claude 交互

或者使用快捷键 Ctrl+Shift+C 打开聊天面板。

### 命令

- `Claude: Open Claude Terminal` - 打开 Claude Code 终端
- `Claude: Start New Session` - 开始新的 Claude 会话
- `Claude: Open Chat Panel` - 打开侧边栏聊天面板

## 要求

- Trae IDE 1.80.0 或更高版本
- Node.js 18.0 或更高版本
- Anthropic API 密钥

## 许可证

MIT License
