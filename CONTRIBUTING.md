# Contributing to fzfgit

Thank you for your interest in contributing to fzfgit!

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists
2. Open a new issue with a clear description
3. Include reproduction steps if applicable

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Test your changes
5. Commit with clear messages
6. Push to your fork
7. Open a pull request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/TheNeovimmer/fzfgit.git
cd fzfgit

# Or add as local plugin in Neovim
# Add to your plugins config:
# { "TheNeovimmer/fzfgit", dir = "~/path/to/fzfgit" }
```

### Code Style

- Use Lua with Neovim conventions
- Follow existing code patterns in the project
- Use descriptive variable names

### Testing

Test your changes manually in Neovim:

```vim
" Load the plugin
:source ~/.config/nvim/lua/plugins/fzfgit.lua

" Or restart Neovim after adding to plugins
```

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
