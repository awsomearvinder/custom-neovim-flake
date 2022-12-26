(fn main []
  (set vim.g.mapleader " ")
  (set vim.o.updatetime 250)
  (set vim.wo.number true)
  (set vim.o.breakindent true)
  (set vim.o.undofile true)
  (set vim.o.ignorecase true)
  (set vim.o.smartcase true)
  (set vim.wo.signcolumn :yes)
  (set vim.o.termguicolors true)
  (set vim.o.completeopt "menuone,noselect")
  (set vim.o.cursorline true)
  (set vim.opt.shell :elvish)
  (vim.cmd "autocmd TermOpen * setlocal scl=no nonumber norelativenumber")
  (vim.cmd "colorscheme gruvbox")
  (let [modules [:lsp
                 :telescope
                 :treesitter
                 :nerdtree
                 :keybindings
                 :orgmode-notes
                 :octo
                 :git-conflict]]
    (each [_ value (ipairs modules)]
      (require (.. :config. value)))))

(main)
