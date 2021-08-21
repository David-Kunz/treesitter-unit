# treesitter-unit

A [Neovim](https://neovim.io/) plugin to deal with [tree-sitter](https://github.com/tree-sitter/tree-sitter) units.
A unit is defined as the parent node (from the beginning of the line) including all its children.
It allows you to quickly select, delete or modify language-specific ranges.

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

### Select treesitter unit:
```
:lua require"treesitter-unit".select()
```

### Delete treesitter unit:
```
:lua require"treesitter-unit".delete()
```

### Change treesitter unit:
```
:lua require"treesitter-unit".change()
```

### Useful mappings:

```
vim.api.nvim_set_keymap('n', 'vx', ':lua require"treesitter-unit".select()<CR>', {noremap=true})
vim.api.nvim_set_keymap('n', 'dx', ':lua require"treesitter-unit".delete()<CR>', {noremap=true})
vim.api.nvim_set_keymap('n', 'cx', ':lua require"treesitter-unit".change()<CR>', {noremap=true})
```

## Similar plugins

[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) for more fine-granular control
