# fzfgit

An interactive Neovim git plugin that wraps git operations using Telescope for simplicity and productivity.

## Requirements

- [Neovim](https://github.com/neovim/neovim) >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [Git](https://git-scm.com)

## Installation

### Lazy

```lua
return {
  "TheNeovimmer/fzfgit",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = { "Fgco", "Fgadd", "Fgres", "Fgbr", "Fgst", "Fglog" },
  keys = {
    { "<leader>go", "<cmd>Fgco<cr>", desc = "Git checkout branch" },
    { "<leader>ga", "<cmd>Fgadd<cr>", desc = "Git add files" },
    { "<leader>gr", "<cmd>Fgres<cr>", desc = "Git reset files" },
    { "<leader>gb", "<cmd>Fgbr<cr>", desc = "Git branches" },
    { "<leader>gs", "<cmd>Fgst<cr>", desc = "Git stash" },
    { "<leader>gl", "<cmd>Fglog<cr>", desc = "Git log" },
  },
}
```

### Manual

Add to your `init.lua` or plugin manager:

```lua
require("fzfgit").setup()
```

## Commands

| Command | Description |
|---------|-------------|
| `:Fgco` | Checkout branch interactively |
| `:Fgadd` | Add files to staging area |
| `:Fgres` | Reset staged files |
| `:Fgbr` | Branch management menu |
| `:Fgst` | Stash operations menu |
| `:Fglog` | Browse commit history |

## Keymaps

| Keymap | Description |
|--------|-------------|
| `<leader>go` | Checkout branch |
| `<leader>ga` | Add files |
| `<leader>gr` | Reset files |
| `<leader>gb` | Branch management |
| `<leader>gs` | Stash operations |
| `<leader>gl` | Commit history |

## Features

### Checkout Branch (Fgco)
- Lists local and remote branches
- Preview branch commits
- Quick checkout with Enter

### Add Files (Fgadd)
- Browse untracked and modified files
- Preview file diffs
- Stage files with Enter

### Unstage Files (Fgres)
- View currently staged files
- Preview staged changes
- Unstage with Enter or Ctrl+d

### Branch Management (Fgbr)
- Create new branch
- Delete existing branch
- Rename branch

### Stash Operations (Fgst)
- List all stashes with preview
- Apply stash (Enter)
- Pop stash (Ctrl+p)
- Drop stash (Ctrl+d)

### Git Log (Fglog)
- Browse recent commits
- Full commit preview
- Copy commit hash (y)

## License

MIT
