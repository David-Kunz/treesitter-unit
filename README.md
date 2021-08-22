# treesitter-unit

A tiny [Neovim](https://neovim.io/) plugin to deal with [tree-sitter](https://github.com/tree-sitter/tree-sitter) units.
A unit is defined as a tree-sitter node including all its children.
It allows you to quickly select, yank, delete or replace language-specific ranges.

The first node of the current line will be selected (or the next node in case of empty lines).

![demo](https://user-images.githubusercontent.com/1009936/130320180-1ca6380b-134e-4356-9ff9-5da623741922.gif)

## Installation

Requirements: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

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
```
:lua require"treesitter-unit".select()
```
This function takes an optional Boolean flag to specify if the outer scope should be selected as well.

### Useful mappings

For init.vim:
```
vnoremap x :lua require"treesitter-unit".select()<CR>
vnoremap ax :lua require"treesitter-unit".select(true)<CR>
onoremap x :<c-u>lua require"treesitter-unit".select()<CR>
onoremap ax :<c-u>lua require"treesitter-unit".select(true)<CR>
```
For init.lua:
```
vim.api.nvim_set_keymap('v', 'x', ':lua require"treesitter-unit".select()<CR>', {noremap=true})
vim.api.nvim_set_keymap('v', 'ax', ':lua require"treesitter-unit".select(true)<CR>', {noremap=true})
vim.api.nvim_set_keymap('o', 'x', ':<c-u>lua require"treesitter-unit".select()<CR>', {noremap=true})
vim.api.nvim_set_keymap('o', 'ax', ':<c-u>lua require"treesitter-unit".select(true)<CR>', {noremap=true})
```

## Similar plugins

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) for more fine-granular control
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection) for incremental selection
