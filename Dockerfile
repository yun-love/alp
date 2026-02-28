# 必须指定 32 位架构，供 WebVM 使用
FROM --platform=linux/386 alpine:latest

# 1. 安装系统依赖和 C++ 开发环境
RUN apk add --no-cache \
    clang \
    clang-extra-tools \
    cmake \
    make \
    g++ \
    git \
    neovim \
    ripgrep \
    fd \
    unzip \
    curl \
    nodejs \
    npm \
    bash \
    build-base

# 2. 安装 pnpm (使用官方推荐的无干扰安装方式)
RUN npm install -g pnpm

# 3. 配置 Neovim 目录并复制配置
RUN mkdir -p /root/.config/nvim
COPY init.lua /root/.config/nvim/init.lua

# 4. 只克隆 Lazy.nvim 源码，绝不在此处运行 nvim
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
    /root/.local/share/nvim/lazy/lazy.nvim

# 设置默认工作目录和终端
WORKDIR /workspace
ENTRYPOINT ["/bin/bash", "-l"]
