FROM alpine:latest

# 1. 安装基础包 (去掉 GDB 减重)
RUN apk add --no-cache \
    clang clang-extra-tools cmake make g++ \
    git neovim ripgrep fd unzip curl nodejs npm bash build-base

# 2. 安装 pnpm
RUN npm install -g pnpm

# 3. 预设 Neovim 环境
RUN mkdir -p /root/.config/nvim
COPY init.lua /root/.config/nvim/init.lua

# 4. 预装 Lazy.nvim 插件管理器并同步插件
# 设置环境变量让 Lazy 在 headless 模式下运行
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git /root/.local/share/nvim/lazy/lazy.nvim
RUN nvim --headless "+Lazy! sync" +qa

WORKDIR /workspace
ENTRYPOINT ["/bin/bash", "-l"]
