-- No external dependencies required – uses only built-in Neovim 0.12+ APIs.
local options = {}
local M = {}

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function get_text(bufnr, line)
  return vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
end

local function get_node_for_cursor(cursor)
  if cursor == nil then
    cursor = vim.api.nvim_win_get_cursor(0)
  end
  return vim.treesitter.get_node({ pos = { cursor[1] - 1, cursor[2] } })
end

local function get_main_node(cursor)
  local node = get_node_for_cursor(cursor)
  if not node then return nil end
  -- Phase 1: walk up through transparent wrappers (exact same range).
  -- e.g. call_expression and expression_statement share the same range.
  local sr, sc, er, ec = node:range()
  local parent = node:parent()
  while parent ~= nil and parent:parent() ~= nil do
    local psr, psc, per, pec = parent:range()
    if psr ~= sr or psc ~= sc or per ~= er or pec ~= ec then break end
    node = parent
    parent = node:parent()
  end
  -- Phase 2: if we're still at a leaf-like node (no named children), walk up
  -- while the parent starts at the same position — this promotes bare
  -- identifiers/literals into their containing expression.
  -- e.g. `console` (identifier) → `console.log("no")` (call_expression)
  if node:named_child_count() == 0 then
    local leaf_sr, leaf_sc = node:start()
    parent = node:parent()
    while parent ~= nil and parent:parent() ~= nil do
      local psr, psc = parent:start()
      if psr ~= leaf_sr or psc ~= leaf_sc then break end
      node = parent
      parent = node:parent()
      -- re-run phase 1 to skip transparent wrappers at this level
      local nsr, nsc, ner, nec = node:range()
      while parent ~= nil and parent:parent() ~= nil do
        local p2sr, p2sc, p2er, p2ec = parent:range()
        if p2sr ~= nsr or p2sc ~= nsc or p2er ~= ner or p2ec ~= nec then break end
        node = parent
        parent = node:parent()
      end
    end
  end
  return node
end

local function move_row_while_empty(bufnr, curr_line, delta)
  local line = curr_line
  if get_text(bufnr, line) == '' then
    local parent = line + delta
    local line_parent = get_text(bufnr, parent)
    while parent >= 0 and line_parent == '' do
      line = parent
      parent = line + delta
      line_parent = get_text(bufnr, parent)
    end
  end
  return line
end

local function move_col_while_empty(bufnr, curr_line)
  local text = get_text(bufnr, curr_line)
  local found = string.find(text, '[^%s]')
  return found and found - 1 or 0
end

local function select_range(bufnr, start_row, start_col, end_row, end_col, mode)
  start_row = start_row + 1
  start_col = start_col + 1
  end_row   = end_row + 1
  end_col   = end_col + 1
  mode = mode or 'v'
  local cur_mode = vim.api.nvim_get_mode().mode
  if cur_mode == 'v' or cur_mode == 'V' or cur_mode == '\22' then
    -- x-mode: already in visual. Navigate with motions (setpos doesn't work here).
    vim.cmd('normal! ' .. start_row .. 'G' .. start_col .. '|o' .. end_row .. 'G' .. (end_col - 1) .. '|')
  else
    -- o-mode: setpos to start, enter visual, setpos to end.
    vim.fn.setpos('.', { bufnr, start_row, start_col, 0 })
    vim.cmd('normal! ' .. mode)
    vim.fn.setpos('.', { bufnr, end_row, end_col - 1, 0 })
  end
end

-- ---------------------------------------------------------------------------
-- Core selection logic
-- ---------------------------------------------------------------------------

local function get_selection_range(outer)
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local sel_row = cursor[1]
  local sel_col = cursor[2]

  if outer and get_text(bufnr, sel_row) == '' then
    sel_row = move_row_while_empty(bufnr, sel_row, 1) + 1
    sel_col = 0
  end
  if outer then
    sel_col = move_col_while_empty(bufnr, sel_row)
  end

  local node = get_main_node({ sel_row, sel_col })
  if not node then return end

  local start_row, start_col, end_row, end_col = node:range()

  local mode = 'v'
  if outer then
    if cursor[1] < sel_row then
      -- cursor was on blank line above: absorb leading blank lines
      start_row = move_row_while_empty(bufnr, start_row, -1) - 1
      start_col = 0
      mode = 'V'
    else
      local text = get_text(bufnr, end_row + 2)
      if text == '' then
        -- blank line follows: absorb trailing blank lines
        end_row = move_row_while_empty(bufnr, end_row + 2, 1) - 1
        start_col = 0
        mode = 'V'
      else
        -- no blank line after: check for preceding blank line to absorb
        -- start_row is 0-indexed; get_text takes 1-indexed
        local prev_line_1idx = start_row  -- line just before node (1-indexed = start_row+1-1 = start_row)
        if start_row > 0 and get_text(bufnr, prev_line_1idx) == '' then
          -- move_row_while_empty takes 1-indexed, returns 1-indexed
          start_row = move_row_while_empty(bufnr, prev_line_1idx, -1) - 1
        end
        start_col = 0
        mode = 'V'
      end
    end
  end
  return start_row, start_col, end_row, end_col, mode
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

M.select = function(outer)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col, mode = get_selection_range(outer)
  if start_row == nil then return end
  select_range(bufnr, start_row, start_col, end_row, end_col, mode)
end

-- ---------------------------------------------------------------------------
-- Highlighting
-- ---------------------------------------------------------------------------

local highlight_ns = vim.api.nvim_create_namespace('treesitter-unit-ns')
local highlight_augroup = vim.api.nvim_create_augroup('treesitter-unit-highlight', { clear = true })

M.highlight_unit = function(higroup)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
  local start_row, start_col, end_row, end_col = get_selection_range()
  if start_row == nil then return end
  vim.hl.range(bufnr, highlight_ns, higroup, { start_row, start_col }, { end_row, end_col })
end

local highlighting_enabled = false

M.enable_highlighting = function(higroup)
  local used_higroup = higroup or 'CursorLine'
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = highlight_augroup,
    callback = function() M.highlight_unit(used_higroup) end,
  })
  M.highlight_unit(used_higroup)
  highlighting_enabled = true
end

M.disable_highlighting = function()
  vim.api.nvim_clear_autocmds({ group = highlight_augroup })
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, highlight_ns, 0, -1)
  highlighting_enabled = false
end

M.toggle_highlighting = function(higroup)
  if highlighting_enabled then
    M.disable_highlighting()
  else
    M.enable_highlighting(higroup)
  end
end

-- ---------------------------------------------------------------------------
-- Delete / Change
-- ---------------------------------------------------------------------------

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

M.setup = function(opts)
  options = vim.tbl_deep_extend('force', options, opts)
end

return M
