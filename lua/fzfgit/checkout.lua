local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_branches()
  local local_branches = vim.fn.systemlist("git branch 2>/dev/null | sed 's/^[* ] //'")
  local remote_branches = vim.fn.systemlist("git branch -r 2>/dev/null | sed 's/^[* ] //' | grep -v HEAD")

  local branches = {}
  for _, b in ipairs(local_branches) do
    table.insert(branches, { name = b, type = "local" })
  end
  for _, b in ipairs(remote_branches) do
    local name = b:gsub("^origin/", "")
    local found = false
    for _, existing in ipairs(branches) do
      if existing.name == name then
        found = true
        break
      end
    end
    if not found then
      table.insert(branches, { name = name, type = "remote" })
    end
  end
  return branches
end

local function get_branch_preview(_, entry)
  local branch_name = entry.value.name
  local cmd = string.format("git log --oneline -10 %s 2>/dev/null || echo 'No commits'", branch_name)
  return vim.fn.system(cmd)
end

local function checkout_branch(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local branch_name = selection.value.name
  vim.cmd(string.format("git checkout %s", branch_name))
  actions.close(prompt_bufnr)
end

local M = {}

function M.pick()
  local branches = get_branches()
  if #branches == 0 then
    vim.notify("No branches found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Checkout Branch",
    finder = finders.new_table({
      results = branches,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name .. " (" .. entry.type .. ")",
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = get_branch_preview,
    }),
    attach_mappings = function(_, map)
      map("i", "<CR>", checkout_branch)
      map("n", "<CR>", checkout_branch)
      return true
    end,
  }):pick()
end

return M
