local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_changed_files()
  local files = vim.fn.systemlist("git diff --name-only --cached 2>/dev/null")
  local result = {}
  for _, f in ipairs(files) do
    if f ~= "" then
      table.insert(result, { filename = f, status = "staged" })
    end
  end
  return result
end

local function get_file_diff(_, entry)
  return vim.fn.system("git diff --cached -- " .. entry.value.filename)
end

local function stage_files(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local filename = selection.value.filename
  vim.cmd(string.format("git add %s", filename))
  actions.close(prompt_bufnr)
  vim.cmd("Fgres")
end

local M = {}

function M.pick()
  local files = get_changed_files()
  if #files == 0 then
    vim.notify("No staged files to reset", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Unstage Files",
    finder = finders.new_table({
      results = files,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.filename .. " (staged)",
          ordinal = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = get_file_diff,
    }),
    attach_mappings = function(_, map)
      map("i", "<CR>", stage_files)
      map("n", "<CR>", stage_files)
      map("i", "<C-d>", function(prompt_bufnr)
        local selection = actions.get_selected_entry(prompt_bufnr)
        if selection then
          local filename = selection.value.filename
          vim.cmd(string.format("git reset HEAD -- %s", filename))
          vim.cmd("Fgres")
        end
      end)
      return true
    end,
  }):pick()
end

return M
