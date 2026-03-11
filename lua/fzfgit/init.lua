local fzfgit = {}

function fzfgit.setup()
  vim.api.nvim_create_user_command("Fgco", function()
    require("fzfgit.checkout").pick()
  end, { desc = "Git checkout branch" })

  vim.api.nvim_create_user_command("Fgadd", function()
    require("fzfgit.add").pick()
  end, { desc = "Git add files" })

  vim.api.nvim_create_user_command("Fgres", function()
    require("fzfgit.reset").pick()
  end, { desc = "Git reset files" })

  vim.api.nvim_create_user_command("Fgbr", function()
    require("fzfgit.branch").menu()
  end, { desc = "Git branch management" })

  vim.api.nvim_create_user_command("Fgst", function()
    require("fzfgit.stash").menu()
  end, { desc = "Git stash operations" })

  vim.api.nvim_create_user_command("Fglog", function()
    require("fzfgit.log").pick()
  end, { desc = "Git log browser" })
end

return fzfgit
