local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_untracked_files()
  local files = vim.fn.systemlist("git ls-files --others --exclude-standard 2>/dev/null")
  local result = {}
  for _, f in ipairs(files) do
    if f ~= "" then
      table.insert(result, { filename = f, status = "untracked" })
    end
  end
  local modified = vim.fn.systemlist("git diff --name-only 2>/dev/null")
  for _, f in ipairs(modified) do
    if f ~= "" then
      table.insert(result, { filename = f, status = "modified" })
    end
  end
  return result
end

local function get_file_preview(_, entry)
  local filename = entry.value.filename
  if entry.value.status == "modified" then
    return vim.fn.system("git diff -- " .. filename)
  end
  return vim.fn.system("cat " .. filename)
end

local function stage_file(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  if not selection then
    return
  end
  local filename = selection.value.filename
  vim.cmd(string.format("git add %s", filename))
  actions.close(prompt_bufnr)
end

local M = {}

function M.pick()
  local files = get_untracked_files()
  if #files == 0 then
    vim.notify("No files to add", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Add Files",
    finder = finders.new_table({
      results = files,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.filename .. " (" .. entry.status .. ")",
          ordinal = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = get_file_preview,
    }),
    attach_mappings = function(_, map)
      map("i", "<CR>", stage_file)
      map("n", "<CR>", stage_file)
      return true
    end,
  }):pick()
end

return M
