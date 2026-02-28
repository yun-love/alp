-- 基础配置
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Lazy.nvim 引导
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- LSP 支持
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.clangd.setup{}
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
    -- 自动补全
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({{ name = 'nvim_lsp' }})
            })
        end
    },
    -- 配色方案 (选一个不需要特殊字体的)
    { "ellisonleao/gruvbox.nvim", priority = 1000, config = function() vim.cmd([[colorscheme gruvbox]]) end },
    ui = {
        icons = {
            cmd = "⌘", config = "🛠", event = "📅", ft = "📂", init = "⚙",
            import = "📦", keys = "🗝", plugin = "🔌", runtime = "💻",
            require = "🌙", source = "📄", start = "🚀", task = "📌", lazy = "💤 ",
        },
    },
})
