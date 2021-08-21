# treesitter-unit

A [Neovim](https://neovim.io/) plugin to deal with [tree-sitter](https://github.com/tree-sitter/tree-sitter) units.
A unit is defined as the parent node including all its children.

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
