local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_stashes()
  local output = vim.fn.systemlist("git stash list 2>/dev/null")
  local result = {}
  for _, line in ipairs(output) do
    if line ~= "" then
      local stash_ref = line:gsub("stash@{%d+}: ", "")
      table.insert(result, { ref = line, description = stash_ref })
    end
  end
  return result
end

local function get_stash_preview(_, entry)
  local ref = entry.value.ref
  local index = ref:match("stash@{(%d+)}")
  return vim.fn.system("git stash show -p stash@{" .. index .. "}")
end

local function apply_stash(prompt_bufnr, pop)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local ref = selection.value.ref
  local index = ref:match("stash@{(%d+)}")
  local cmd = pop and "git stash pop" or "git stash apply"
  vim.cmd(string.format("%s stash@{%s}", cmd, index))
  actions.close(prompt_bufnr)
end

local function drop_stash(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local ref = selection.value.ref
  local index = ref:match("stash@{(%d+)}")
  vim.cmd(string.format("git stash drop stash@{%s}", index))
  actions.close(prompt_bufnr)
end

local M = {}

function M.menu()
  local stashes = get_stashes()
  if #stashes == 0 then
    vim.notify("No stashes found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Git Stash",
    finder = finders.new_table({
      results = stashes,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.ref .. ": " .. entry.description,
          ordinal = entry.ref .. " " .. entry.description,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = get_stash_preview,
    }),
    attach_mappings = function(_, map)
      map("i", "<CR>", function(pb) apply_stash(pb, false) end)
      map("n", "<CR>", function(pb) apply_stash(pb, false) end)
      map("i", "<C-p>", function(pb) apply_stash(pb, true) end)
      map("n", "<C-p>", function(pb) apply_stash(pb, true) end)
      map("i", "<C-d>", drop_stash)
      map("n", "<C-d>", drop_stash)
      return true
    end,
  }):pick()
end

return M
