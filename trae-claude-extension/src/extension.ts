import * as vscode from 'vscode';
import { spawn } from 'child_process';
import * as path from 'path';
import * as os from 'os';

let claudeTerminal: vscode.Terminal | undefined;
let chatViewProvider: ChatViewProvider | undefined;

export function activate(context: vscode.ExtensionContext) {
    console.log('Claude Code for Trae is now active!');

    chatViewProvider = new ChatViewProvider(context.extensionUri);
    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider('traeClaude.chatView', chatViewProvider)
    );

    const openTerminalCommand = vscode.commands.registerCommand('traeClaude.openTerminal', async () => {
        await openClaudeTerminal();
    });

    const startSessionCommand = vscode.commands.registerCommand('traeClaude.startSession', async () => {
        await startNewSession();
    });

    const openChatCommand = vscode.commands.registerCommand('traeClaude.openChat', async () => {
        await vscode.commands.executeCommand('workbench.view.extension.traeClaude');
    });

    context.subscriptions.push(openTerminalCommand, startSessionCommand, openChatCommand);

    context.subscriptions.push(
        vscode.window.onDidCloseTerminal((terminal) => {
            if (terminal === claudeTerminal) {
                claudeTerminal = undefined;
            }
        })
    );
}

class ChatViewProvider implements vscode.WebviewViewProvider {
    public static readonly viewType = 'traeClaude.chatView';
    private _view?: vscode.WebviewView;

    constructor(private readonly _extensionUri: vscode.Uri) {}

    public resolveWebviewView(
        webviewView: vscode.WebviewView,
        _context: vscode.WebviewViewResolveContext,
        _token: vscode.CancellationToken
    ) {
        this._view = webviewView;
        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [this._extensionUri]
        };
        webviewView.webview.html = this._getHtmlForWebview(webviewView.webview);
    }

    private _getHtmlForWebview(webview: vscode.Webview): string {
        return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claude Chat</title>
    <style>
        body {
            padding: 10px;
            font-family: var(--vscode-font-family);
            color: var(--vscode-editor-foreground);
            background-color: var(--vscode-editor-background);
        }
        .container {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 20px);
        }
        .header {
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--vscode-panel-border);
        }
        .header h2 {
            margin: 0;
            font-size: 16px;
        }
        .messages {
            flex: 1;
            overflow-y: auto;
            margin-bottom: 10px;
        }
        .message {
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 4px;
        }
        .user-message {
            background-color: var(--vscode-button-secondaryBackground);
        }
        .assistant-message {
            background-color: var(--vscode-editor-inactiveSelectionBackground);
        }
        .input-container {
            display: flex;
            gap: 8px;
        }
        input[type="text"] {
            flex: 1;
            padding: 8px;
            background-color: var(--vscode-input-background);
            color: var(--vscode-input-foreground);
            border: 1px solid var(--vscode-input-border);
            border-radius: 4px;
        }
        button {
            padding: 8px 16px;
            background-color: var(--vscode-button-background);
            color: var(--vscode-button-foreground);
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: var(--vscode-button-hoverBackground);
        }
        .info {
            padding: 10px;
            background-color: var(--vscode-notificationInfoBackground);
            border-radius: 4px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🤖 Claude Code</h2>
        </div>
        <div class="info">
            <p>Use the "Open Claude Terminal" command to start a full Claude Code session.</p>
        </div>
        <div class="messages" id="messages"></div>
        <div class="input-container">
            <input type="text" id="input" placeholder="Type a message...">
            <button onclick="sendMessage()">Send</button>
        </div>
    </div>
    <script>
        const vscode = acquireVsCodeApi();
        const messagesDiv = document.getElementById('messages');
        const input = document.getElementById('input');

        function addMessage(content, isUser) {
            const div = document.createElement('div');
            div.className = 'message ' + (isUser ? 'user-message' : 'assistant-message');
            div.textContent = content;
            messagesDiv.appendChild(div);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }

        function sendMessage() {
            const message = input.value.trim();
            if (!message) return;
            addMessage(message, true);
            input.value = '';
            addMessage('Please use the Claude Terminal for full functionality.', false);
        }

        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
</body>
</html>`;
    }
}

async function openClaudeTerminal() {
    const config = vscode.workspace.getConfiguration('traeClaude');
    const apiKey = config.get<string>('apiKey', '');
    const autoInstall = config.get<boolean>('autoInstall', true);

    if (!apiKey) {
        const result = await vscode.window.showInformationMessage(
            'Please set your Anthropic API Key first.',
            'Open Settings'
        );
        if (result === 'Open Settings') {
            vscode.commands.executeCommand('workbench.action.openSettings', 'traeClaude.apiKey');
        }
        return;
    }

    if (claudeTerminal) {
        claudeTerminal.show();
        return;
    }

    const claudeAvailable = await checkClaudeAvailable();
    if (!claudeAvailable) {
        if (autoInstall) {
            const installResult = await vscode.window.showInformationMessage(
                'Claude Code CLI is not installed. Would you like to install it now?',
                'Install',
                'Cancel'
            );
            if (installResult === 'Install') {
                await installClaude();
            } else {
                return;
            }
        } else {
            vscode.window.showErrorMessage('Claude Code CLI is not installed. Please install it first.');
            return;
        }
    }

    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    const cwd = workspaceFolder?.uri.fsPath || os.homedir();

    claudeTerminal = vscode.window.createTerminal({
        name: 'Claude Code',
        cwd: cwd,
        env: {
            ...process.env,
            ANTHROPIC_API_KEY: apiKey
        }
    });

    claudeTerminal.sendText('claude');
    claudeTerminal.show();
}

async function startNewSession() {
    await openClaudeTerminal();
    if (claudeTerminal) {
        claudeTerminal.sendText('/reset');
    }
}

async function checkClaudeAvailable(): Promise<boolean> {
    return new Promise((resolve) => {
        const check = spawn('claude', ['--version'], {
            shell: true,
            stdio: 'ignore'
        });

        check.on('close', (code) => {
            resolve(code === 0);
        });

        check.on('error', () => {
            resolve(false);
        });
    });
}

async function installClaude(): Promise<void> {
    return new Promise((resolve, reject) => {
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Installing Claude Code...',
            cancellable: false
        }, async (progress) => {
            progress.report({ message: 'Downloading and installing...' });

            const install = spawn(
                'npm',
                ['install', '-g', 'https://mirrors.cloud.tencent.com/npm/@anthropic-ai/claude-code/-/claude-code-2.1.88.tgz'],
                {
                    shell: true,
                    stdio: 'pipe'
                }
            );

            let output = '';
            install.stdout?.on('data', (data) => {
                output += data.toString();
            });

            install.stderr?.on('data', (data) => {
                output += data.toString();
            });

            install.on('close', (code) => {
                if (code === 0) {
                    vscode.window.showInformationMessage('Claude Code installed successfully!');
                    resolve();
                } else {
                    vscode.window.showErrorMessage(`Failed to install Claude Code: ${output}`);
                    reject(new Error(output));
                }
            });

            install.on('error', (err) => {
                vscode.window.showErrorMessage(`Failed to install Claude Code: ${err.message}`);
                reject(err);
            });
        });
    });
}

export function deactivate() {
    if (claudeTerminal) {
        claudeTerminal.dispose();
    }
}
