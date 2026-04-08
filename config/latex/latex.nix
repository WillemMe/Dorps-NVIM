# LaTeX Language Support Configuration for NVF
# This module provides comprehensive LaTeX support including:
# - LSP (texlab) for completion, diagnostics, and hover docs
# - Treesitter syntax highlighting for .tex and .bib files
# - Diagnostics (chktex) for LaTeX linting via miktex
# - Additional LaTeX tools (texpresso, latexmk via texlive)
{pkgs, ...}: let
  # Embed chktexrc configuration
  chktexrcContent = builtins.readFile ./chktexrc;
  # Embed texlab.lua as the source of truth for LSP configuration
  texlabConfig = builtins.readFile ./texlab.lua;
  indentConfigPath = ./indentconfig.yaml; # This will be a Nix store path
in {
  config.vim = {
    # =============================================================================
    # LSP Configuration (texlab) - Uses texlab.lua as source of truth
    # =============================================================================
    luaConfigRC.texlab-lsp = ''
            -- Texlab LSP Configuration
            -- Source of truth: texlab.lua

            -- Guard: Ensure texlab is available in PATH
            if vim.fn.executable('${pkgs.texlab}/bin/texlab') ~= 1 then
              vim.notify('texlab not found in PATH', vim.log.levels.WARN)
              return
            end

            -- Load the texlab configuration from embedded file
            -- This is the complete texlab.lua configuration
            local texlab_config = (function()
      ${texlabConfig}
            end)()

            -- Override cmd with Nix-provided path
            texlab_config.cmd = { '${pkgs.texlab}/bin/texlab' }

            -- Override cmd with Nix-provided path
            texlab_config.settings.texlab.latexindent['local'] = '${indentConfigPath}'


            -- Register and enable Texlab LSP using modern Neovim 0.11+ API
            -- DISABLED vim.lsp.config('texlab', texlab_config)

            -- Enable the LSP for current and future buffers
            -- DISABLED vim.lsp.enable('texlab')
    '';

    # =============================================================================
    # Treesitter Configuration
    # =============================================================================
    treesitter = {
      enable = true;
      grammars = [
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.latex
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.bibtex
      ];
    };

    # =============================================================================
    # Required Packages
    # =============================================================================
    extraPackages = with pkgs; [
      # LSP Server
      texlab

      # Linter (chktex from miktex)
      #miktex

      # LaTeX distribution (includes latexmk, pdflatex, etc.)
      #texliveMedium

      # Live preview tool
      #texpresso

      # PDF viewer for forward search (optional, comment out if not needed)
      #zathura
    ];

    # =============================================================================
    # Additional Plugins
    # =============================================================================
    # extraPlugins = {
    #   # Texpresso plugin for live LaTeX preview
    #   "texpresso.vim" = {
    #     package = pkgs.vimPlugins.texpresso-vim;
    #   };
    # };

    # =============================================================================
    # Filetype Configuration
    # =============================================================================
    luaConfigRC.latex-config = ''
            -- Write chktexrc to a persistent location
            local chktexrc_content = [==[
      ${chktexrcContent}]==]

            local config_dir = vim.fn.stdpath('config')
            local chktexrc_path = config_dir .. '/chktexrc'

            -- Write the chktexrc file if it doesn't exist or needs updating
            local file = io.open(chktexrc_path, 'w')
            if file then
              file:write(chktexrc_content)
              file:close()
            end

            -- LaTeX-specific settings
            vim.api.nvim_create_autocmd("FileType", {
              pattern = {"tex", "latex"},
              callback = function()
                -- Disable automatic comment continuation
                vim.opt_local.formatoptions:remove({ "c", "r", "o" })

                -- Set text width for LaTeX files
                vim.opt_local.textwidth = 80

                -- Disable Neovim's built-in spell checking (using Codebook LSP instead)
                vim.opt_local.spell = false

                -- Concealment settings for LaTeX (optional)
                vim.opt_local.conceallevel = 2
                vim.opt_local.concealcursor = ""

                -- Disable format on save for LaTeX files
                vim.b.autoformat = false
              end,
            })

            -- BibTeX-specific settings
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "bib",
              callback = function()
                vim.opt_local.textwidth = 80
                -- Disable Neovim's built-in spell checking (using Codebook LSP instead)
                vim.opt_local.spell = false
              end,
            })
    '';
  };
}
