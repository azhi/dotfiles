-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

--Remap comma as leader key
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

-- Add plugins
require('lazy').setup("plugins")

--Make line numbers default
vim.wo.number = true
vim.wo.numberwidth = 3

--Autoformat options
vim.opt.formatoptions:remove({'t', 'c'})
vim.opt.formatoptions:append({r = true, n = true, ['1'] = true})

-- Briefly show matching bracket
vim.go.showmatch = true

-- some more space between lines
vim.go.linespace = 2

-- show whitespace chars
vim.opt.listchars = {tab = '»·', trail = '·'}
vim.opt.wildignore = {'.svn', '.git', '.hg', '*.o', '*.a', '*.class', '*.mo', '*.la', '*.so', '*.obj', '*.swp', '*.jpg', '*.png', '*.xpm', '*.gif'}

-- indent stuff
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
-- overridden by cindent
-- vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.cinoptions = ':0,(s,u0,U1,g0,t0'

--Enable mouse mode
vim.o.mouse = 'a'
-- TODO: try to enable filling * buffer automatically on visual selection
-- vim.opt.guioptions:append({'a'})

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,preview,noselect'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme 'OceanicNext'

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

vim.api.nvim_create_autocmd('vimenter', {
  command = 'Neotree source=filesystem',
  pattern = '*',
})

-- spell
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

vim.cmd.cd("~/develop")

vim.keymap.set('n', 'Y', 'y$') -- make Y consistent with C and D
vim.keymap.set('n', '<C-N>', ':silent noh<CR>', { silent = true }) -- Ctrl-N to disable search match highlight
vim.keymap.set('n', '<C-E>', ':b#<CR>') -- Ctrl-E to switch between 2 last buffers
vim.keymap.set({'', '!'}, '<S-Insert>', '<MiddleMouse>') -- Make shift-insert work like in Xterm
vim.keymap.set('v', '<', '<gv') -- keep selection after in/outdent
vim.keymap.set('v', '>', '>gv') -- keep selection after in/outdent
vim.keymap.set('n', '+', '<C-a>') -- easier increment/decrement
vim.keymap.set('n', '-', '<C-x>') -- easier increment/decrement
vim.keymap.set('n', '<C-h>', '<C-w>h') -- easy split navigation
vim.keymap.set('n', '<C-j>', '<C-w>j') -- easy split navigation
vim.keymap.set('n', '<C-k>', '<C-w>k') -- easy split navigation
vim.keymap.set('n', '<C-l>', '<C-w>l') -- easy split navigation
vim.keymap.set('n', 's', '"_d') -- make s a delete without spoiling register

-- TODO: disable format for buffer
-- TODO: swap * and # - make # use n for next, N for prev
-- TODO: check markdown ft detection?
-- TODO: find or write GBlame
-- TODO: spellcheck?

-- vim: ts=2 sts=2 sw=2 et
