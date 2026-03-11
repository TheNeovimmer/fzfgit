local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_commits()
  local output = vim.fn.systemlist("git log --oneline -50 2>/dev/null")
  local result = {}
  for _, line in ipairs(output) do
    if line ~= "" then
      local hash, msg = line:match("^([a-f0-9]+) (.+)")
      if hash and msg then
        table.insert(result, { hash = hash, message = msg, full = line })
      end
    end
  end
  return result
end

local function get_commit_preview(_, entry)
  local hash = entry.value.hash
  return vim.fn.system("git show --stat --format=fuller " .. hash)
end

local function copy_hash(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local hash = selection.value.hash
  vim.fn.setreg("+", hash)
  vim.notify("Copied: " .. hash, vim.log.levels.INFO)
  actions.close(prompt_bufnr)
end

local function checkout_commit(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local hash = selection.value.hash
  vim.cmd(string.format("git checkout %s", hash))
  actions.close(prompt_bufnr)
end

local M = {}

function M.pick()
  local commits = get_commits()
  if #commits == 0 then
    vim.notify("No commits found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Git Log",
    finder = finders.new_table({
      results = commits,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.full,
          ordinal = entry.full,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = get_commit_preview,
    }),
    attach_mappings = function(_, map)
      map("i", "<CR>", checkout_commit)
      map("n", "<CR>", checkout_commit)
      map("i", "y", copy_hash)
      map("n", "y", copy_hash)
      return true
    end,
  }):pick()
end

return M
