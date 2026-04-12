#!/usr/bin/env bash
# oh-my-tmux 安装脚本
# 用途：在新机器上一键配置 tmux 环境（WSL2 / Linux）

set -e

REPO_URL="git@github.com:jinzaizhichi/.tmux.git"
TMUX_DIR="$HOME/.tmux"
TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_LOCAL="$HOME/.tmux.conf.local"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# 颜色输出
info()    { echo -e "\033[1;34m[INFO]\033[0m $*"; }
success() { echo -e "\033[1;32m[OK]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error()   { echo -e "\033[1;31m[ERROR]\033[0m $*"; exit 1; }

# 1. 检查 tmux 是否安装
if ! command -v tmux &>/dev/null; then
    error "tmux 未安装。请先安装 tmux：\n  Arch: sudo pacman -S tmux\n  Ubuntu: sudo apt install tmux"
fi
info "tmux 版本: $(tmux -V)"

# 2. 克隆或更新 oh-my-tmux repo
if [ -d "$TMUX_DIR/.git" ]; then
    info "~/.tmux 已存在，拉取最新代码..."
    git -C "$TMUX_DIR" pull --ff-only || warn "git pull 失败，跳过更新"
else
    info "克隆 oh-my-tmux..."
    git clone "$REPO_URL" "$TMUX_DIR"
fi

# 3. 创建符号链接（~/.tmux.conf -> ~/.tmux/.tmux.conf）
if [ -L "$TMUX_CONF" ]; then
    success "符号链接已存在: $TMUX_CONF"
elif [ -f "$TMUX_CONF" ]; then
    warn "~/.tmux.conf 是普通文件，备份为 ~/.tmux.conf.bak"
    mv "$TMUX_CONF" "$TMUX_CONF.bak"
    ln -sf "$TMUX_DIR/.tmux.conf" "$TMUX_CONF"
    success "符号链接已创建: $TMUX_CONF -> $TMUX_DIR/.tmux.conf"
else
    ln -sf "$TMUX_DIR/.tmux.conf" "$TMUX_CONF"
    success "符号链接已创建: $TMUX_CONF -> $TMUX_DIR/.tmux.conf"
fi

# 4. 部署 .tmux.conf.local（个人配置）
if [ -f "$TMUX_CONF_LOCAL" ]; then
    # 检查是否与 repo 版本相同
    if diff -q "$TMUX_DIR/.tmux.conf.local" "$TMUX_CONF_LOCAL" &>/dev/null; then
        success "~/.tmux.conf.local 已是最新"
    else
        warn "~/.tmux.conf.local 与 repo 版本不同，备份为 ~/.tmux.conf.local.bak"
        cp "$TMUX_CONF_LOCAL" "$TMUX_CONF_LOCAL.bak"
        cp "$TMUX_DIR/.tmux.conf.local" "$TMUX_CONF_LOCAL"
        success "~/.tmux.conf.local 已更新"
    fi
else
    cp "$TMUX_DIR/.tmux.conf.local" "$TMUX_CONF_LOCAL"
    success "~/.tmux.conf.local 已部署"
fi

# 5. 安装 tpm（Tmux Plugin Manager）
if [ -d "$TPM_DIR/.git" ]; then
    success "tpm 已安装"
else
    info "安装 tpm..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    success "tpm 安装完成"
fi

# 6. 完成提示
echo ""
success "安装完成！"
echo ""
echo "下一步："
echo "  1. 启动或重载 tmux：tmux source ~/.tmux.conf"
echo "  2. 安装插件：在 tmux 中按 <prefix> + I（大写 i）"
echo "  3. 等待插件安装完毕后重新加载配置"
echo ""
echo "已启用的插件："
echo "  - tmux-sensible        合理默认值"
echo "  - tmux-resurrect       保存/恢复 session（prefix + Ctrl-s / Ctrl-r）"
echo "  - tmux-continuum       自动保存（每 15 分钟）"
echo "  - vim-tmux-navigator   Neovim ↔ tmux 无缝切换（Ctrl+h/j/k/l）"
echo ""
echo "vim-tmux-navigator 提示："
echo "  Neovim 侧需要安装对应插件，lazy.nvim 配置："
echo '  { "christoomey/vim-tmux-navigator" }'
