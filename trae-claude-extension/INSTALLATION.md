# 安装和使用指南

## 项目概述

本项目已成功完成以下任务：

1. ✅ 克隆了两个 GitHub 项目：
   - [claude_code_src](https://github.com/ponponon/claude_code_src) - Claude Code 2.1.88 的源码恢复项目
   - [Trae-Ralph](https://github.com/ylubi/Trae-Ralph) - Trae IDE 自动化工具

2. ✅ 创建了完整的 VS Code 扩展 `trae-claude-extension`，用于将 Claude Code 集成到 Trae IDE 中

## 扩展功能

### 核心功能

- **Claude Code 终端集成** - 在 Trae IDE 中直接启动 Claude Code 终端
- **API 密钥管理** - 在 Trae IDE 设置中配置 Anthropic API 密钥
- **自动安装** - 自动检测并安装 Claude Code CLI
- **侧边栏聊天面板** - 提供便捷的聊天界面
- **快捷键支持** - Ctrl+Shift+C 快速打开聊天面板

### 可用命令

1. `Claude: Open Claude Terminal` - 打开 Claude Code 终端
2. `Claude: Start New Session` - 开始新的 Claude 会话
3. `Claude: Open Chat Panel` - 打开侧边栏聊天面板

## 安装扩展

### 方法一：从源码构建

1. 进入扩展目录：
```bash
cd /workspace/trae-claude-extension
```

2. 安装依赖：
```bash
npm install
```

3. 编译 TypeScript：
```bash
npm run compile
```

4. 在 Trae IDE 中测试：
   - 打开 Trae IDE
   - 按 F5 启动扩展开发主机
   - 在新窗口中测试扩展

### 方法二：打包为 VSIX

1. 安装 vsce 工具：
```bash
npm install -g @vscode/vsce
```

2. 打包扩展：
```bash
cd /workspace/trae-claude-extension
vsce package
```

3. 这会生成一个 `.vsix` 文件，可以在 Trae IDE 中安装：
   - 打开 Trae IDE
   - 按 Ctrl+Shift+P 打开命令面板
   - 输入 "Extensions: Install from VSIX..."
   - 选择生成的 `.vsix` 文件

## 使用扩展

### 1. 配置 API 密钥

1. 打开 Trae IDE 设置（Ctrl+,）
2. 搜索 "Claude Code"
3. 在 "API Key" 字段中输入你的 Anthropic API 密钥
4. 保存设置

### 2. 启动 Claude

#### 方式一：使用终端

1. 按 Ctrl+Shift+P 打开命令面板
2. 输入 "Claude: Open Claude Terminal"
3. 如果 Claude Code CLI 未安装，扩展会提示你安装
4. 安装完成后，终端会自动启动并运行 `claude` 命令

#### 方式二：使用侧边栏

1. 点击活动栏中的 Claude Code 图标（紫色圆圈）
2. 在侧边栏中查看聊天界面
3. 点击 "Open Claude Terminal" 按钮启动完整功能

#### 方式三：使用快捷键

- 按 Ctrl+Shift+C (Windows/Linux) 或 Cmd+Shift+C (Mac) 打开侧边栏

## 项目结构

```
/workspace/
├── projects/
│   ├── claude_code_src/          # Claude Code 源码恢复项目
│   │   ├── src/                  # 源代码
│   │   ├── node_modules/         # 依赖
│   │   └── claude-code-2.1.88.tgz  # 完整的 npm 包
│   └── Trae-Ralph/               # Trae IDE 自动化工具
│       ├── src/                  # 源代码
│       └── templates/            # 规则和技能模板
└── trae-claude-extension/        # 我们创建的 VS Code 扩展
    ├── src/
    │   └── extension.ts          # 扩展主文件
    ├── resources/
    │   └── icon.svg              # 扩展图标
    ├── package.json              # 扩展配置
    ├── tsconfig.json             # TypeScript 配置
    └── README.md                 # 说明文档
```

## 技术细节

### claude_code_src 项目

这是 Claude Code 2.1.88 版本的源码恢复项目，包含：
- 完整的 70 万行源码
- 与 VS Code、JetBrains 等 IDE 的集成代码
- MCP (Model Context Protocol) 实现
- 插件系统架构

### Trae-Ralph 项目

这是一个通过 Chrome DevTools Protocol 为 Trae IDE 实现自动化持续工作的工具，包含：
- CDP (Chrome DevTools Protocol) 集成
- 场景检测和自动响应
- 编辑器 API 封装
- 规则和技能模板系统

### trae-claude-extension 项目

我们创建的 VS Code 扩展，特点包括：
- 使用 TypeScript 开发
- 集成 VS Code API
- WebView 聊天面板
- 终端集成
- 配置管理

## 下一步

1. 在 Trae IDE 中安装和测试扩展
2. 根据需要调整扩展功能
3. 考虑更深度的集成，如：
   - 直接在 WebView 中调用 Claude API
   - 集成 MCP 协议
   - 添加更多 Trae IDE 特定的功能

## 注意事项

- 确保你有有效的 Anthropic API 密钥
- 扩展需要 Node.js 18+ 环境
- Claude Code CLI 需要网络连接
- 首次安装可能需要一些时间

## 获取帮助

如有问题，请参考：
- [Claude Code 文档](https://code.claude.com/docs)
- [Trae IDE 文档](https://trae.ai/docs)
- 扩展的 README.md 文件
