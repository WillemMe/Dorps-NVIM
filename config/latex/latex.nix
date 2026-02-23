# LaTeX Language Support Configuration for NVF
# This module provides comprehensive LaTeX support including:
# - LSP (texlab) for completion, diagnostics, and hover docs
# - Treesitter syntax highlighting for .tex and .bib files
# - Diagnostics (chktex) for LaTeX linting via miktex
# - Additional LaTeX tools (texpresso, latexmk via texlive)
{pkgs, ...}: let
  # Embed chktexrc configuration
  chktexrcContent = builtins.readFile ./chktexrc;
in {
  config.vim = {
    # =============================================================================
    # LSP Configuration (texlab)
    # =============================================================================
    lsp = {
      enable = true;
      lspconfig = {
        enable = true;
        sources.texlab = ''
          -- Suppress lspconfig deprecation warning
          local notify_once = vim.notify_once
          vim.notify_once = function(msg, ...)
            if type(msg) == "string" and msg:match("lspconfig.*deprecated") then
              return
            end
            return notify_once(msg, ...)
          end

          lspconfig.texlab.setup {
            capabilities = capabilities,
            on_attach = default_on_attach,
            cmd = {"${pkgs.texlab}/bin/texlab"},
            settings = {
              texlab = {
                -- Build configuration (disabled)
             -- --   build = {
             -- --     executable = "latexmk",
             -- --     args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
             -- --     onSave = false,
             -- --     forwardSearchAfter = false,
             -- --   },
             -- --   -- Forward search configuration (for PDF viewers)
             -- --   forwardSearch = {
             -- --     executable = "zathura",
             -- --     args = { "--synctex-forward", "%l:1:%f", "%p" },
             -- --   },
                -- Diagnostics settings
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                -- Lint configuration
                chktex = {
                  onEdit = false,  -- Run chktex on file edit
                  onOpenAndSave = true, -- Run chktex on open and save
                  additionalArgs = {"--localrc", vim.fn.stdpath('config') .. '/chktexrc'},
                },
                lint = {
                  onChange = false,
                },
              },
            },
          }

          -- Restore original notify_once
          vim.notify_once = notify_once
        '';
      };
    };

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
