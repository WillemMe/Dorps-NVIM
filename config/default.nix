_: let
  currentSystemHome = builtins.getEnv "HOME";

  evaledUndoDir =
    if currentSystemHome == ""
    then "/tmp/neovim/undodir"
    else "${currentSystemHome}/.neovim/undodir";
in {
  imports = [
    #./avante.nix
    ./bqf.nix # Added nvim-bqf configuration
    ./bufferline.nix
    ./cheatsheet.nix
    ./harpoon.nix
    ./keymaps.nix
    ./oil.nix
    ./theme.nix
    ./undotree.nix
    ./whichkey.nix
    ./trouble-keymaps.nix
    ./tmux-navigator.nix # Added vim-tmux-navigator
    ./telescope-zoxide.nix # Added telescope-zoxide
    #./latex.nix
    ./typst.nix
  ];

  config.vim = {
    viAlias = true;
    vimAlias = true;
    clipboard = {
      registers = "unnamedplus";
      providers.wl-copy.enable = true; # For Wayland
      providers.xclip.enable = false; # For X11
    };
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    options = {
      clipboard = "unnamedplus";

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;

      wrap = false;

      swapfile = false;
      backup = false;
      foldlevelstart = 99;
      foldcolumn = "1";
      foldlevel = 99;
      foldenable = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 8;
      signcolumn = "yes";

      updatetime = 500;
    };

    undoFile = {
      enable = true;
      path = evaledUndoDir;
    };

    spellcheck = {enable = true;};

    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = true;
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix.enable = true;
      markdown.enable = true;

      bash.enable = true;
      clang.enable = false;
      css.enable = true;
      html.enable = true;
      sql.enable = false;
      java.enable = false;
      kotlin.enable = false;
      ts.enable = false;
      go.enable = false;
      lua.enable = false;
      zig.enable = false;
      python.enable = true;
      #typst.enable = false;
      rust = {
        enable = false;
        crates.enable = false;
      };
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;

      # Fun
      cellular-automaton.enable = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete.nvim-cmp.enable = true;
    snippets.luasnip.enable = true;

    filetree = {neo-tree = {enable = true;};};

    treesitter.context.enable = true;

    telescope = {
      enable = true;
    };

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
    };

    minimap = {
      minimap-vim.enable = false;
      codewindow.enable =
        true; # lighter, faster, and uses lua for configuration
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {nvim-notify.enable = true;};

    projects = {project-nvim.enable = true;};

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      diffview-nvim.enable = true;
      yanky-nvim.enable = false;
      icon-picker.enable = true;
      surround.enable = true;
      leetcode-nvim.enable = true;
      multicursors.enable = true;
      preview.markdownPreview.enable = true;
      images = {image-nvim.enable = false;};
    };

    notes = {
      neorg.enable = false;
      orgmode.enable = false;
      mind-nvim.enable = true;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice = {
        enable = true;
        setupOpts = {cmdline = {view = "cmdline";};};
      };
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
        setupOpts = {
          colorcolumn = ["80" "160"];
          custom_colorcolumn = {
            nix = "110";
            ruby = "120";
            java = "130";
            go = ["90" "130"];
            markdown = ["80" "100"];
            python = ["80" "120"];
          };
          disabled_filetypes = ["help" "NvimTree" "NeoTree" "Neotree" "alpha"];
        };
      };
      fastaction.enable = true;
    };

    session = {nvim-session-manager.enable = false;};

    gestures = {gesture-nvim.enable = false;};

    comments = {comment-nvim.enable = true;};

    presence = {neocord.enable = false;};
  };
}
