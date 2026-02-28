-- 基础设置
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- 加载 Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- 主题配色 (无缝适配普通终端)
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function() vim.cmd([[colorscheme gruvbox]]) end
    },
    
    -- LSP 配置 (C++ 核心补全)
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- 启动 clangd，禁用后台重型索引以节省 WebVM 内存
            require('lspconfig').clangd.setup{
                cmd = { "clangd", "--background-index=false" }
            }
        end
    },
    
    -- 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "cpp", "c", "lua" },
                highlight = { enable = true },
            })
        end
    },
    
    -- 代码自动补全
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = {
                    expand = function(args) require('luasnip').lsp_expand(args.body) end
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                }),
                sources = cmp.config.sources({{ name = 'nvim_lsp' }})
            })
        end
    }
}, {
    -- 禁用 Lazy.nvim 界面中可能乱码的 Nerd Fonts 图标
    ui = {
        icons = {
            cmd = "⌘", config = "🛠", event = "📅", ft = "📂", init = "⚙",
            import = "📦", keys = "🗝", plugin = "🔌", runtime = "💻",
            require = "🌙", source = "📄", start = "🚀", task = "📌", lazy = "💤 ",
        },
    },
})
