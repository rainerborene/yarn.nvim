local M = {}
local cache = {}

function M.cache_installed_packages()
  local cwd = vim.fn.getcwd()
  if cache[cwd] then
    return
  end

  cache[cwd] = {}
  local parse_lines = function(_, data, _)
    for _, line in pairs(data) do
      name = line:match("([^ ]+)@[0-9.]+")
      if name then
        table.insert(cache[cwd], name)
      end
    end
  end

  vim.fn.jobstart("yarn list --depth=0", {
    on_stdout = parse_lines,
    stdout_buffered = true
  })
end

function M.open_package(name)
  local path = "node_modules/" .. name
  if vim.fn.isdirectory(name) then
    vim.cmd("tabedit " .. path)
    vim.cmd("tcd " .. path)
  end
end

function _G.yarn_complete_packages(arg_lead, cmd_line, cursor_pos)
  local filtered = {}
  local cwd = vim.fn.getcwd()
  for _, line in pairs(cache[cwd]) do
    if line:match(arg_lead) then
      table.insert(filtered, line)
    end
  end
  return filtered
end

return M
