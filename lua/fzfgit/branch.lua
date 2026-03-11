local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local branch_actions = {
  { action = "create", label = "Create new branch" },
  { action = "delete", label = "Delete branch" },
  { action = "rename", label = "Rename branch" },
}

local function run_branch_action(action, branch_name)
  if action == "create" then
    vim.ui.input({ prompt = "New branch name: " }, function(name)
      if name and name ~= "" then
        vim.cmd(string.format("git checkout -b %s", name))
      end
    end)
  elseif action == "delete" then
    vim.cmd(string.format("git branch -d %s", branch_name))
  elseif action == "rename" then
    vim.ui.input({ prompt = "New name for " .. branch_name .. ": " }, function(name)
      if name and name ~= "" then
        vim.cmd(string.format("git branch -m %s %s", branch_name, name))
      end
    end)
  end
end

local function execute_action(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end

  local action = selection.value.action
  if action == "create" then
    run_branch_action("create", nil)
  else
    vim.ui.input({ prompt = "Branch name: " }, function(name)
      if name and name ~= "" then
        run_branch_action(action, name)
      end
    end)
  end
  actions.close(prompt_bufnr)
end

local M = {}

function M.menu()
  pickers.new({}, {
    prompt_title = "Branch Management",
    finder = finders.new_table({
      results = branch_actions,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.label,
          ordinal = entry.label,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", execute_action)
      map("n", "<CR>", execute_action)
      return true
    end,
  }):pick()
end

return M
