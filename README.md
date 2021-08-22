# treesitter-unit

A tiny [Neovim](https://neovim.io/) plugin to deal with [treesitter](https://github.com/tree-sitter/tree-sitter) units.
A unit is defined as a treesitter node including all its children.
It allows you to quickly select, yank, delete or replace language-specific ranges.

The first node of the current line will be selected (or the next node in case of empty lines).

![gif](https://user-images.githubusercontent.com/1009936/130351208-292bfc54-b797-447a-8608-7738ab947ee2.gif)

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

Note: The operator-pending mapping (onoremap) allows the usage for operators on the treesitter unit, e.g. `dx` or `cx`.

## Similar plugins

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) for more fine-granular control
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection) for incremental selection
- [nvim-ts-hint-textobject](https://github.com/mfussenegger/nvim-ts-hint-textobject)

## Making-of video
[![](https://i.ytimg.com/vi/dPQfsASHNkg/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLC_iCGCXjipwKLOxHi2OFBR5XAQfw)](https://youtu.be/dPQfsASHNkg "Let's create a Neovim plugin using Treesitter and Lua")
