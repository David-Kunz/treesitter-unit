local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- local get_text = function(bufnr, line)
--   return vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
-- end

local get_node_for_cursor = function(cursor)
  if cursor == nil then
    cursor = vim.api.nvim_win_get_cursor(0)
  end
  local root = ts_utils.get_root_for_position(unpack({ cursor[1] - 1, cursor[2] }))
  if not root then return end
  return root:named_descendant_for_range(cursor[1] -1 , cursor[2], cursor[1] - 1, cursor[2])
end

local get_main_node = function(cursor)
  local node = get_node_for_cursor(cursor)
  if node == nil then
    error("No Treesitter parser found.")
  end
  local parent = node:parent()
  local root = ts_utils.get_root_for_node(node)
  local start_row = node:start()
  while (parent ~= nil and parent ~= root and parent:start() == start_row ) do
    node = parent
    parent = node:parent()
  end
  return node
end

local move_row_while_empty = function(bufnr, curr_line, delta)
  local line = curr_line - 1
  if vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] == '' then
    local parent = line + delta
    local line_parent = vim.api.nvim_buf_get_lines(bufnr, parent, parent + 1, false)[1]
    while parent >= 0 and line_parent == '' do
      line = parent
      parent = line + delta
      line_parent = vim.api.nvim_buf_get_lines(bufnr, parent, parent + 1, false)[1]
    end
  end
  return line + 1
end

local move_col_while_empty = function(bufnr, curr_line)
  local line = curr_line - 1
  local text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
  local found = string.find(text, '[^%s]')
  return found - 1
end

local select_range = function(bufnr, start_row, start_col, end_row, end_col)
  start_row = start_row + 1
  start_col = start_col + 1
  end_row = end_row + 1
  end_col = end_col + 1
  vim.fn.setpos(".", { bufnr, start_row, start_col, 0 })
  vim.cmd("normal! " .. "v", true, true, true)
  vim.fn.setpos(".", { bufnr, end_row, end_col - 1, 0 })
end

M.select = function(outer)

  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local sel_row = cursor[1]
  local sel_col = cursor[2]
  if vim.api.nvim_buf_get_lines(bufnr, sel_row - 1, sel_row, false)[1] == '' then
    sel_row = move_row_while_empty(bufnr, sel_row, 1) + 1
    sel_col = 0
  end
  sel_col = move_col_while_empty(bufnr, sel_row)

  local node = get_main_node({ sel_row, sel_col })
  local start_row, start_col, end_row, end_col = node:range()

  if outer then
    if cursor[1] < sel_row then
      start_row = move_row_while_empty(bufnr, start_row, -1) - 1
    else
      local text = vim.api.nvim_buf_get_lines(bufnr, end_row + 1, end_row + 2, false)[1] 
      if text == '' then
        end_row = move_row_while_empty(bufnr, end_row + 2, 1) - 1
      end
    end
  end
  select_range(bufnr, start_row, start_col, end_row, end_col)

end

M.delete = function(for_change)
  local bufnr = vim.api.nvim_get_current_buf()
  local node = get_main_node()
  local start_row, start_col, end_row, end_col = node:range()
  local replaced = for_change and ' ' or ''
  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replaced })
end

M.change = function()
  M.delete(true)
  vim.cmd('startinsert')
end

return M
