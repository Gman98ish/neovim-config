require("config.lazy")
require("oil").setup()
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true, -- enable syntax highlighting
  }
}
vim.keymap.set("i", "jf", "<esc>")
vim.keymap.set("n", "<Leader> ", "<cmd>noh<CR>")
-- vim.keymap.set("n", ";", ":") vim.keymap.set("n", "-", require("oil").open)

vim.keymap.set("n", "<Leader>fp", function()
  require('telescope.builtin').find_files {
    find_command = { "rg", "--files", "--no-require-git", "-g", '!*migration*', '-g', '!*test*', '-g', '!*mock*' }
  }
end)

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2                                    -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true                                      -- Confirm to save changes before exiting modified buffer
opt.cursorline = true                                   -- Enable highlighting of the current line
opt.expandtab = true                                    -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.laststatus = 3     -- global statusline
opt.linebreak = true   -- Wrap lines at convenient points
-- opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a"        -- Enable mouse mode
opt.number = true      -- Print line number
opt.wrap = false       -- Disable line wrap
opt.tabstop = 4        -- Number of spaces tabs count for
opt.shiftwidth = 4     -- Number of spaces tabs count for
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
      },
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp,
})

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  { "n" },
  "<leader>a",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n",
  "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({ 'hover', 'actions' })
  end,
  { silent = true, buffer = bufnr }
)

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, "<space>", ts_repeat_move.repeat_last_move)

vim.keymap.set({ "n" }, "grd", vim.lsp.buf.definition)
vim.keymap.set({ "n" }, "grn", vim.lsp.buf.rename)
vim.keymap.set({ "n" }, "<leader>F", vim.lsp.buf.format)

vim.keymap.set({ "n" }, "<leader>of", ":e ~/orgfiles/<cr>")

vim.keymap.set({ "n" }, "<leader>sf", function()
  require('telescope.builtin').lsp_document_symbols({ symbols = {'function', 'method'} })
end)

vim.keymap.set({ "n" }, "<leader>ss", function()
  require('telescope.builtin').lsp_document_symbols({})
end)

vim.keymap.set({ "n" }, "<C-j>", ":+5<cr>")
vim.keymap.set({ "n" }, "<S-j>", ":-5<cr>")
vim.keymap.set({ "n" }, "-", ":Oil<cr>")
vim.keymap.set({ "n" }, "<leader>e", ":e ~/.config/nvim<cr>")
vim.keymap.set({ "n" }, "<leader>lu", ":Lazy update<cr>")

vim.lsp.enable('luals')
vim.lsp.enable('phpactor')
vim.lsp.enable('python-lsp-server')

vim.keymap.set({ "n" }, "<leader>tt", require("neotest").run.run)
vim.keymap.set({ "n" }, "<leader>td", function () require("neotest").run.run({ strategy = "dap", suite = false }) end)
vim.keymap.set({ "n" }, "<leader>ts", ":Neotest summary<cr>")
vim.keymap.set({ "n" }, "<leader>ta", function() require("neotest").run.run({ suite = true }) end)
vim.keymap.set({ "n" }, "<leader>to", require("neotest").output.open)
vim.keymap.set({ "n" }, "<leader>tO", function() require("neotest").output.open({enter = true}) end)
vim.keymap.set({ "n" }, "<leader>tp", function() require("neotest").output_panel.toggle() end)

vim.keymap.set({ "n" }, "<leader>dd", function() require("dapui").toggle() end)

vim.lsp.inlay_hint.enable(false)

require('go').setup()

vim.cmd.colorscheme('catppuccin-mocha')
