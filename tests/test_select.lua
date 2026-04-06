local MiniTest = require('mini.test')
local new_set = MiniTest.new_set
local eq = MiniTest.expect.equality

local child = MiniTest.new_child_neovim()

local T = new_set({
  hooks = {
    pre_case = function()
      child.restart({ '-u', 'scripts/minimal_init.lua' })
      child.lua([[
        vim.keymap.set('x', 'iu', function() require'treesitter-unit'.select() end)
        vim.keymap.set('x', 'au', function() require'treesitter-unit'.select(true) end)
        vim.keymap.set('o', 'iu', function() require'treesitter-unit'.select() end)
        vim.keymap.set('o', 'au', function() require'treesitter-unit'.select(true) end)
      ]])
    end,
    post_once = child.stop,
  },
})

-- Helper: set buffer lines, place cursor, type keys, return {lines, cursor}
local function setup_buf(lines, cursor, ft)
  child.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  child.api.nvim_win_set_cursor(0, cursor)
  if ft then child.bo.filetype = ft end
  -- Ensure treesitter parser is active
  child.lua([[vim.treesitter.start()]])
end

local function get_lines() return child.api.nvim_buf_get_lines(0, 0, -1, false) end
local function get_cursor() return child.api.nvim_win_get_cursor(0) end


-- ─── inner unit (iu) ────────────────────────────────────────────────────────

T['diu deletes inner unit - string literal'] = function()
  setup_buf({
    'function greet(name) {',
    '  const msg = "Hello " + name',
    '}',
  }, { 2, 14 }, 'javascript')  -- cursor inside string literal

  child.type_keys('diu')

  -- deletes just the string node
  eq(get_lines(), {
    'function greet(name) {',
    '  const msg =  + name',
    '}',
  })
end

T['diu deletes inner unit - binary expression'] = function()
  setup_buf({
    'function greet(name) {',
    '  const msg = "Hello " + name',
    '}',
  }, { 2, 22 }, 'javascript')  -- cursor on '+', inside binary_expression

  child.type_keys('diu')

  eq(get_lines(), {
    'function greet(name) {',
    '  const msg = ',
    '}',
  })
end

T['diu deletes inner unit - identifier'] = function()
  setup_buf({
    'const x = 42',
  }, { 1, 10 }, 'javascript')  -- cursor on 42

  child.type_keys('diu')

  eq(get_lines(), { 'const x = ' })
end

T['yiu yanks inner unit'] = function()
  setup_buf({
    'const x = 42',
  }, { 1, 10 }, 'javascript')

  child.type_keys('yiu')

  -- cursor should not move, buffer unchanged
  eq(get_lines(), { 'const x = 42' })
  eq(get_cursor(), { 1, 10 })

  -- register should contain yanked text
  local reg = child.fn.getreg('"')
  eq(reg, '42')
end

T['ciu changes inner unit'] = function()
  setup_buf({
    'const x = 42',
  }, { 1, 10 }, 'javascript')

  child.type_keys('ciu', 'insert_mode')
  -- just check we're in insert mode after ciu
  eq(child.api.nvim_get_mode().mode, 'i')
end

T['viu selects inner unit visually'] = function()
  setup_buf({
    'const x = 42',
  }, { 1, 10 }, 'javascript')

  child.type_keys('v', 'iu')

  eq(child.api.nvim_get_mode().mode, 'v')
  child.type_keys('d')
  eq(get_lines(), { 'const x = ' })
end

-- ─── outer unit (au) ────────────────────────────────────────────────────────

T['dau on statement with trailing empty line'] = function()
  -- au includes the trailing empty line (linewise)
  setup_buf({
    'const x = 1',
    '',
    'const y = 2',
  }, { 1, 0 }, 'javascript')

  child.type_keys('dau')

  eq(get_lines(), { 'const y = 2' })
end

T['dau on statement without trailing empty line'] = function()
  -- no empty line after: same as diu but linewise not triggered
  setup_buf({
    'const x = 1',
    'const y = 2',
  }, { 1, 0 }, 'javascript')

  child.type_keys('dau')

  eq(get_lines(), { 'const y = 2' })
end

T['dau on last statement with preceding empty line'] = function()
  setup_buf({
    'const x = 1',
    '',
    'const y = 2',
  }, { 3, 0 }, 'javascript')

  child.type_keys('dau')

  -- y deleted; preceding blank line absorbed
  eq(get_lines(), {
    'const x = 1',
  })
end

-- ─── regression: cursor on indented line inside else-branch ────────────────────

T['diu inside else-branch selects call expression, not whole if'] = function()
  setup_buf({
    'if (true) {',
    '  console.log("yes")',
    '} else {',
    '  console.log("no")',
    '}',
  }, { 4, 2 }, 'javascript')  -- cursor on whitespace before second console.log

  child.type_keys('diu')

  eq(get_lines(), {
    'if (true) {',
    '  console.log("yes")',
    '} else {',
    '  ',
    '}',
  })
end

return T
