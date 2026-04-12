# tmux 配置

基于 [oh-my-tmux](https://github.com/gpakosz/.tmux) 框架的个人 tmux 配置，针对 WSL2 + Neovim (NvChad) + Gruvbox Dark 工作流优化。

## 效果预览

- Gruvbox Dark 配色，与 NvChad 主题统一
- Powerline 分隔符（需要 Nerd Font）
- 状态栏显示 session 名、系统运行时间、时间日期、用户名、主机名

## 快速安装

```bash
bash ~/.tmux/install.sh
```

安装完成后在 tmux 里按 `prefix + I`（大写）安装插件。

### 手动安装

```bash
# 克隆仓库
git clone git@github.com:jinzaizhichi/.tmux.git ~/.tmux

# 创建符号链接
ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf

# 部署个人配置
cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

# 安装 tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 环境要求

| 依赖 | 版本 | 说明 |
|------|------|------|
| tmux | >= 2.3 | 主程序 |
| Nerd Font | 任意 | Powerline 分隔符 |
| git | 任意 | 克隆仓库、tpm |
| clip.exe | WSL2 内置 | Windows 剪贴板集成 |

## 键位说明

prefix 键为 `Ctrl+b`（默认）。

### 常用操作

| 按键 | 功能 |
|------|------|
| `prefix + \|` | 水平分割 pane（保留当前路径）|
| `prefix + -` | 垂直分割 pane（保留当前路径）|
| `prefix + c` | 新建窗口（保留当前路径）|
| `prefix + r` | 重载配置 |
| `prefix + e` | 编辑 ~/.tmux.conf.local |
| `prefix + q` | 显示 pane 编号 |
| `prefix + z` | 最大化/还原当前 pane |
| `prefix + t` | 显示时钟 |

### pane 切换

| 按键 | 功能 |
|------|------|
| `Ctrl+h` | 切换到左侧 pane |
| `Ctrl+j` | 切换到下方 pane |
| `Ctrl+k` | 切换到上方 pane |
| `Ctrl+l` | 切换到右侧 pane |

> 由 vim-tmux-navigator 提供，在 Neovim 和 tmux pane 之间无缝切换，无需区分是在编辑器还是终端里。Neovim 侧需安装同名插件。

### 复制模式（vi 键位）

| 按键 | 功能 |
|------|------|
| `prefix + [` | 进入复制模式 |
| `v` | 开始选择 |
| `y` | 复制选中内容（WSL2 同步到 Windows 剪贴板）|
| `Enter` | 复制并退出 |
| `q` | 退出复制模式 |

### session 管理

| 按键 | 功能 |
|------|------|
| `prefix + Ctrl-s` | 保存 session（tmux-resurrect）|
| `prefix + Ctrl-r` | 恢复 session（tmux-resurrect）|

> tmux-continuum 每 15 分钟自动保存，重启 tmux 时自动恢复上次 session。

## 插件列表

| 插件 | 功能 |
|------|------|
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | 合理默认值（转义延迟、终端类型等）|
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | 手动保存和恢复 session |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | 自动保存（15分钟间隔），启动自动恢复 |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Neovim ↔ tmux pane 无缝切换 |

## 主要配置项

| 配置 | 值 | 说明 |
|------|----|------|
| history-limit | 50000 | 历史记录行数 |
| mouse | on | 鼠标滚动、点击切换 |
| base-index | 1 | 窗口/pane 从 1 开始编号 |
| mode-keys | vi | 复制模式使用 vi 键位 |
| 配色方案 | Gruvbox Dark | 与 NvChad 统一 |
| 剪贴板 | clip.exe | WSL2 同步到 Windows |
| 自动保存间隔 | 15 分钟 | tmux-continuum |

## 个人配置

所有个人配置写在 `~/.tmux.conf.local`，不要修改 `~/.tmux.conf`（符号链接，更新 repo 会覆盖）。

```
~/.tmux.conf          # 符号链接 → ~/.tmux/.tmux.conf（不要手动修改）
~/.tmux.conf.local    # 个人配置（在这里改）
~/.tmux/.tmux.conf.local  # 同上，repo 里的副本
```

## 分支说明

本仓库维护两个分支：

| 分支 | 用途 |
|------|------|
| `master` | 与上游 [oh-my-tmux](https://github.com/gpakosz/.tmux) 保持同步，不做个人修改 |
| `personal` | 个人使用分支，在 master 基础上叠加个人配置（本分支）|

## 更新工作流

### 同步上游更新

```bash
# 1. 切到 master，拉取上游最新
git checkout master
git pull origin master

# 2. 切回 personal，rebase 到新的 master
git checkout personal
git rebase master

# 3. 冲突时保留个人版本（README、install.sh、.tmux.conf.local）
# git checkout --theirs <file>
# git add <file>
# git rebase --continue

# 4. 推送
git push origin personal --force-with-lease
```

### 修改个人配置

```bash
# 在 personal 分支上修改、提交即可
git checkout personal
# ... 修改 .tmux.conf.local 等
git add .
git commit -m "feat: xxx"
git push origin personal
```

### 更新 tpm 插件

在 tmux 里按 `prefix + U`。

## Neovim 集成

在 lazy.nvim 里添加 vim-tmux-navigator：

```lua
{ "christoomey/vim-tmux-navigator" }
```

安装后 `Ctrl+h/j/k/l` 可在 Neovim 窗口和 tmux pane 之间自由切换。
