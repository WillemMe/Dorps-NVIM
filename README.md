# NVF Neovim Configuration

A declarative, modular Neovim configuration built with
[NVF](https://github.com/notashelf/nvf) (Neovim Flake) and Nix. Optimized for
technical writing (LaTeX/Typst), software development, and bilingual spell
checking (EN/NL).

## Quick Start

### Local Usage

```bash
# Build the configuration
nix build

# Run Neovim
./result/bin/nvim

# Or run directly without building
nix run
```

## Key Features

### Core Functionality

- **LSP Support**: Format-on-save, diagnostics, code actions, lightbulb hints
- **DAP Integration**: nvim-dap with UI for debugging
- **Tree-sitter**: Syntax highlighting and code navigation
- **Auto-completion**: nvim-cmp with luasnip snippets
- **Git Integration**: Fugitive, gitsigns, diffview, lazygit via toggleterm

### Language Support

- **LaTeX**: Texlab LSP, latexmk build system, Zathura PDF viewer with forward
  search, ChkTeX linting
- **Typst**: Tinymist LSP, typstyle formatter, live preview support
- **Python**: Full LSP and formatting support
- **Nix**: Language server with formatting
- **Markdown**: LSP with preview capabilities
- **Others**: Bash, CSS, HTML

### Spell Checking

- **Codebook LSP**: Modern Rust-based spell checker via LSP protocol
- **Multi-language**: English (US) and Dutch (NL) with easy language switching
- **Smart dictionaries**: Project-local and global word lists
- **Supported files**: Markdown, LaTeX, Typst, Nix, Git commits, plain text

### Notable Plugins

- **Harpoon**: Lightning-fast navigation between frequently used files
- **Oil.nvim**: Edit filesystem like a buffer with delete-to-trash support
- **Telescope**: Fuzzy finder with zoxide integration
- **Neo-tree**: File explorer with rich functionality
- **Trouble**: Diagnostics and quickfix panel
- **Undotree**: Visual undo history browser
- **Custom BV Plugins**: Company-specific tools (selecttool, urldecode,
  tpshelper)

### UI/UX

- **Theme**: Catppuccin Mocha with transparency
- **Suggestions**: Show suggestions after `<leader>` press
- **Status Line**: Lualine with minimalist separators
- **Dashboard**: Alpha greeting screen
- **Notifications**: nvim-notify for non-intrusive messages
- **Noice**: Enhanced command line and message UI
- **Visual Enhancements**: Indent guides, highlight-undo, cursorline,
  breadcrumbs

## Essential Keybindings

Leader key: `<Space>`

### Navigation & Editing

| Key               | Mode   | Action                                  |
| ----------------- | ------ | --------------------------------------- |
| `<leader>ff`      | Normal | Telescope, find open filenames          |
| `<leader>fg`      | Normal | Telescope, ripgrep on project           |
| `<C-n>`           | Normal | Open file explorer                      |
| `<C-d>` / `<C-u>` | Normal | Half-page down/up with auto-center      |
| `n` / `N`         | Normal | Next/prev search with auto-center       |
| `J` / `K`         | Visual | Move selected lines down/up             |
| `H` / `L`         | Visual | Indent left/right (maintains selection) |

### File Management

| Key           | Mode   | Action                        |
| ------------- | ------ | ----------------------------- |
| `<C-n>`       | Normal | Toggle Neo-tree file explorer |
| `-`           | Normal | Open Oil.nvim file browser    |
| `<leader>a`   | Normal | Harpoon: Mark file            |
| `<C-e>`       | Normal | Harpoon: Quick menu           |
| `<C-h/j/k/l>` | Normal | Harpoon: Jump to file 1-4     |

### Spell Checking (Codebook LSP)

| Key                           | Mode   | Action                                   |
| ----------------------------- | ------ | ---------------------------------------- |
| `<leader>sa`                  | Normal | Show code actions                        |
| `<leader>ss`                  | Normal | Show suggestions                         |
| `<leader>sf`                  | Normal | Quick fix spelling                       |
| `<leader>sd` / `sg`           | Normal | Add to project/global dictionary         |
| `<leader>sle` / `sln` / `slb` | Normal | Switch to EN/NL/Both, (restart required) |

### Git & Development

| Key          | Mode   | Action                  |
| ------------ | ------ | ----------------------- |
| `<leader>gs` | Normal | Git status (Fugitive)   |
| `<leader>f`  | Normal | Format current buffer   |
| `<leader>u`  | Normal | Toggle undotree         |
| `<leader>h`  | Normal | Clear search highlights |

## Configuration Structure

```
.
├── flake.nix              # Main flake entry point
├── flake.lock             # Dependency lock file
└── config/
    ├── default.nix        # Core settings and module imports
    ├── theme.nix          # Catppuccin theme configuration
    ├── keymaps.nix        # Custom keybindings
    ├── harpoon.nix        # Fast file navigation
    ├── oil.nix            # Filesystem-as-buffer editor
    ├── undotree.nix       # Visual undo history
    ├── bv.nix             # Custom work-specific plugins
    ├── snippets.nix       # Code snippet definitions
    ├── latex/             # LaTeX language support
    ├── typst.nix          # Typst document format
    └── spell/             # Codebook LSP spell checking
```

## Multi-Platform Support

This configuration supports:

- Linux: `x86_64-linux`, `aarch64-linux`
- macOS: `x86_64-darwin` (Intel), `aarch64-darwin` (Apple Silicon)

## Customization

- **Core settings**: Edit `config/default.nix`
- **Keybindings**: Modify `config/keymaps.nix`
- **Theme**: Adjust `config/theme.nix`
- **Enable/disable plugins**: Toggle feature flags in `config/default.nix`

## Dependencies

All dependencies are managed through Nix flakes:

- `nixpkgs` (nixos-unstable channel)
- `nvf` (Neovim Flake framework)

No manual plugin installation required.
