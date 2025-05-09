require("config.lazy")
require("oil").setup()
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true, -- enable syntax highlighting
    }
}
vim.keymap.set("i", "jf", "<esc>")
vim.keymap.set("n", "<Leader> ", "<cmd>noh<CR>")
-- vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "-", require("oil").open)

vim.keymap.set("n", "<Leader>fp", function ()
    require('telescope.builtin').find_files {
        find_command = {"rg", "--files", "--no-require-git", "-g", '!*migration*', '-g', '!*test*', '-g', '!*mock*'}
    }
end)

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
-- opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.wrap = false -- Disable line wrap
opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Number of spaces tabs count for
opt.smartindent = true -- Insert indents automatically
opt.autoindent = true
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}

vim.lsp.config['gopls'] = {
    settings = {
        gopls = {
            buildFlags = {"-tags=integration"}
        }
    }
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, "<space>", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, "<C-Space>", ts_repeat_move.repeat_last_move_opposite)

vim.keymap.set({"n"}, "grd", vim.lsp.buf.definition)
vim.keymap.set({"n"}, "<leader>F", vim.lsp.buf.format)

vim.keymap.set({ "n" }, "<leader>of", ":e ~/orgfiles/<cr>")

vim.lsp.enable('luals')
vim.lsp.enable('gopls')
vim.cmd.colorscheme('vesper')
