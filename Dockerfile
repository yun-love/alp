# 必须指定 --platform=linux/386，否则 WebVM 无法运行
FROM --platform=linux/386 alpine:latest

# 1. 安装基础工具链
# 删除了 gdb 以减小体积，保留 clang, cmake, nodejs, pnpm 等
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

# 2. 安装 pnpm (注意修复了你之前报错的软链接问题)
RUN npm install -g pnpm

# 3. 配置 Neovim 路径
RUN mkdir -p /root/.config/nvim
# 假设你的 init.lua 在仓库根目录，这里将其复制进镜像
COPY init.lua /root/.config/nvim/init.lua

# 4. 预装 Lazy.nvim 插件管理器
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
    /root/.local/share/nvim/lazy/lazy.nvim

# 5. 【关键】在构建镜像时预先同步所有插件
# 这样你在机房打开时，插件已经是现成的，不需要联网
RUN nvim --headless "+Lazy! sync" +qa

# 6. 设置工作目录
WORKDIR /workspace

# 强制使用 bash 以获得更好的交互体验
ENTRYPOINT ["/bin/bash", "-l"]
