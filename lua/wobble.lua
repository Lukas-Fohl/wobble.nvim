local M = {}

local default = {
  source_exts = { "c", "cpp", "cc", "cxx", "m", "mm", "c++" },
  header_exts = { "h", "hpp", "hh", "hxx", "h++" },
  search_paths = { ".", "./src", "./include", "./../src", "./../include" },
}

local config = {}

local function split_basename(full)
  local name, ext = full:match("(.+)%.(.+)")
  return name, ext
end

local function build_counterparts(name, ext, list)
  local t = {}
  for _, e in ipairs(list) do
    table.insert(t, name .. "." .. e)
  end
  return t
end

local function find_first(candidates)
  for _, candidate in ipairs(candidates) do
    for _, path in ipairs(config.search_paths) do
      local found = vim.fn.findfile(candidate, path .. ";")
      if found ~= "" then
        return found
      end
    end
  end
  return nil
end

function M.switch()
  local cur = vim.fn.expand("%:t")
  local name, ext = split_basename(cur)

  if not name or not ext then
    vim.notify("Unable to parse current file name")
    return
  end

  local is_source = false
  for _, e in ipairs(config.source_exts) do
    if e == ext then is_source = true end
  end

  local is_header = false
  for _, e in ipairs(config.header_exts) do
    if e == ext then is_header = true end
  end

  if not (is_source or is_header) then
    vim.notify("Current file extension not in source/header lists")
    return
  end

  local candidates
  if is_source then
    candidates = build_counterparts(name, ext, config.header_exts)
  else
    candidates = build_counterparts(name, ext, config.source_exts)
  end

  local found = find_first(candidates)

  -- if not found and is_header then
  --   candidates = build_counterparts(name, ext, config.source_exts)
  --   found = find_first(candidates)
  -- end

  if not found then
    vim.notify("Could not locate a counterpart for " .. cur)
    return
  end

  vim.cmd("edit " .. found)
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", {}, default, opts or {})

  vim.api.nvim_create_user_command("Wobble", M.switch, {})
end

return M
