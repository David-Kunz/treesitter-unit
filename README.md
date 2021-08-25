# treesitter-unit

A tiny [Neovim](https://neovim.io/) plugin to deal with [treesitter](https://github.com/tree-sitter/tree-sitter) units.
A unit is defined as a treesitter node including all its children.
It allows you to quickly select, yank, delete or replace language-specific ranges.

For inner selections, the main node under the cursor is selected.
For outer selections, the next node is selected.

![demo-with-highlight](https://user-images.githubusercontent.com/1009936/130355705-5da61f06-52a9-43f4-a98c-7e2df3ae175b.gif)

## Installation

Requirements: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) including a parser for your language

For [vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'David-Kunz/treesitter-unit'
```
For [packer](https://github.com/wbthomason/packer.nvim):
```
use 'David-Kunz/treesitter-unit'
```

## Usage

### Select treesitter unit
You can select the current treesitter unit
```
:lua require"treesitter-unit".select(outer?)
```
This function takes an optional Boolean flag to specify if the outer scope should be selected as well, default `false`.
For operations like delete, change, ... please see section "Useful mappings".

### Automatic Highlighting
You can toggle automatic highlighting for the current treesitter unit.
```
:lua require"treesitter-unit".toggle_highlighting(higroup?)
```
As an optional parameter you can specify the highlight group, default: `"CursorLine"`.
Alternative:
`:lua require"treesitter-unit".enable_highlighting(higroup?)` and `:lua require"treesitter-unit".disable_highlighting()`.

### Useful mappings

For init.vim:
```
xnoremap iu :lua require"treesitter-unit".select()<CR>
xnoremap au :lua require"treesitter-unit".select(true)<CR>
onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>
```
For init.lua:
```
vim.api.nvim_set_keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', {noremap=true})
vim.api.nvim_set_keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', {noremap=true})
vim.api.nvim_set_keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', {noremap=true})
vim.api.nvim_set_keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', {noremap=true})
```

Examples:
- `viu` to select the inner unit
- `cau` to change the outer unit


## Similar plugins

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) for more fine-granular control
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection) for incremental selection
- [nvim-ts-hint-textobject](https://github.com/mfussenegger/nvim-ts-hint-textobject)

## Making-of video
[![](https://i.ytimg.com/vi/dPQfsASHNkg/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLC_iCGCXjipwKLOxHi2OFBR5XAQfw)](https://youtu.be/dPQfsASHNkg "Let's create a Neovim plugin using Treesitter and Lua")
