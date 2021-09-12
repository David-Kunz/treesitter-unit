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

Alternative: `enable_highlighting(higroup?)` and `disable_highlighting()`.

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


## Tested in:

<table>
<th>
<td>Working</td></th>
<tr>
<td>bash</td><td> </td></tr>
<tr>
<td>beancount</td><td> </td></tr>
<tr>
<td>bibtex</td><td> </td></tr>
<tr>
<td>c</td><td> </td></tr>
<tr>
<td>c_sharp</td><td> </td></tr>
<tr>
<td>clojure</td><td> </td></tr>
<tr>
<td>cmake</td><td> </td></tr>
<tr>
<td>comment</td><td> </td></tr>
<tr>
<td>commonlisp</td><td> </td></tr>
<tr>
<td>cpp</td><td> </td></tr>
<tr>
<td>css</td><td> </td></tr>
<tr>
<td>cuda</td><td> </td></tr>
<tr>
<td>dart</td><td> </td></tr>
<tr>
<td>devicetree</td><td> </td></tr>
<tr>
<td>dockerfile</td><td> </td></tr>
<tr>
<td>elixir</td><td> </td></tr>
<tr>
<td>elm</td><td> </td></tr>
<tr>
<td>erlang</td><td> </td></tr>
<tr>
<td>fennel</td><td> </td></tr>
<tr>
<td>fish</td><td> </td></tr>
<tr>
<td>fortran</td><td> </td></tr>
<tr>
<td>Godot (gdscript)</td><td> </td></tr>
<tr>
<td>Glimmer and Ember</td><td> </td></tr>
<tr>
<td>go</td><td></td></tr>
<tr>
<td>Godot Resources (gdresource)</td><td> </td></tr>
<tr>
<td>gomod</td><td> </td></tr>
<tr>
<td>graphql</td><td> </td></tr>
<tr>
<td>haskell</td><td> </td></tr>
<tr>
<td>hcl</td><td> </td></tr>
<tr>
<td>heex</td><td> </td></tr>
<tr>
<td>html</td><td> </td></tr>
<tr>
<td>java</td><td> </td></tr>
<tr>
<td>javascript</td><td></td></tr>
<tr>
<td>jsdoc</td><td> </td></tr>
<tr>
<td>json</td><td> </td></tr>
<tr>
<td>json5</td><td> </td></tr>
<tr>
<td>JSON with comments</td><td> </td></tr>
<tr>
<td>julia</td><td> </td></tr>
<tr>
<td>kotlin</td><td> </td></tr>
<tr>
<td>latex</td><td> </td></tr>
<tr>
<td>ledger</td><td> </td></tr>
<tr>
<td>lua</td><td> </td></tr>
<tr>
<td>nix</td><td> </td></tr>
<tr>
<td>ocaml</td><td> </td></tr>
<tr>
<td>ocaml_interface</td><td> </td></tr>
<tr>
<td>ocamllex</td><td> </td></tr>
<tr>
<td>php</td><td></td></tr>
<tr>
<td>python</td><td></td></tr>
<tr>
<td>ql</td><td> </td></tr>
<tr>
<td>Tree-sitter query language</td><td> </td></tr>
<tr>
<td>r</td><td> </td></tr>
<tr>
<td>regex</td><td> </td></tr>
<tr>
<td>rst</td><td></td></tr>
<tr>
<td>ruby</td><td></td></tr>
<tr>
<td>rust</td><td></td></tr>
<tr>
<td>scala</td><td> </td></tr>
<tr>
<td>scss</td><td> </td></tr>
<tr>
<td>sparql</td><td> </td></tr>
<tr>
<td>supercollider</td><td> </td></tr>
<tr>
<td>surface</td><td> </td></tr>
<tr>
<td>svelte</td><td> </td></tr>
<tr>
<td>swift</td><td> </td></tr>
<tr>
<td>teal</td><td> </td></tr>
<tr>
<td>tlaplus</td><td> </td></tr>
<tr>
<td>toml</td><td> </td></tr>
<tr>
<td>tsx</td><td> </td></tr>
<tr>
<td>turtle</td><td> </td></tr>
<tr>
<td>typescript</td><td></td></tr>
<tr>
<td>verilog</td><td> </td></tr>
<tr>
<td>vim</td><td> </td></tr>
<tr>
<td>vue</td><td> </td></tr>
<tr>
<td>yaml</td><td> </td></tr>
<tr>
<td>yang</td><td> </td></tr>
<tr>
<td>zig</td><td> </td></tr>
</table>
<!--textobjectinfo-->

## Similar plugins

- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) for more fine-granular control
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection) for incremental selection
- [nvim-ts-hint-textobject](https://github.com/mfussenegger/nvim-ts-hint-textobject)

## Making-of video
[![](https://i.ytimg.com/vi/dPQfsASHNkg/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLC_iCGCXjipwKLOxHi2OFBR5XAQfw)](https://youtu.be/dPQfsASHNkg "Let's create a Neovim plugin using Treesitter and Lua")
