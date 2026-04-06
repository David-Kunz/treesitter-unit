-- Add the plugin itself to runtimepath
vim.opt.runtimepath:prepend(vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h'))

-- Add mini.test (dev-only dep, not bundled)
local mini_test_path = vim.fn.expand('~/.local/share/nvim/site/pack/mine/opt/mini.test')
vim.opt.runtimepath:prepend(mini_test_path)

-- Add nvim-treesitter (for queries)
local ts_path = vim.fn.expand('~/.local/share/nvim/site/pack/core/opt/nvim-treesitter')
vim.opt.runtimepath:prepend(ts_path)

-- Add the site dir so installed parsers (e.g. javascript.so) are found
vim.opt.runtimepath:prepend(vim.fn.expand('~/.local/share/nvim/site'))
