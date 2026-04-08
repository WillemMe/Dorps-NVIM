# Codebook LSP Configuration
# Provides spell checking via LSP for source code and documentation
# Uses the actively maintained Codebook LSP (Rust-based, actively maintained)
{pkgs, ...}: let
  # Embed preset configurations as Nix strings for portability
  # These presets can be activated via :SpellLangEn, :SpellLangNl, :SpellLangBoth commands
  enPreset = builtins.readFile ./codebook.en.toml;
  nlPreset = builtins.readFile ./codebook.nl.toml;
  bothPreset = builtins.readFile ./codebook.both.toml;
in {
  config.vim = {
    # =============================================================================
    # Required Packages
    # =============================================================================
    extraPackages = with pkgs; [
      # Codebook LSP server (Rust-based, fast, actively maintained)
      codebook
    ];

    # =============================================================================
    # LSP Configuration (Neovim 0.11+ native API)
    # =============================================================================
    luaConfigRC.codebook-lsp = ''
      -- Codebook LSP Configuration
      -- Uses codebook-lsp for spell checking in source code

      -- Guard: Ensure codebook-lsp is available in PATH
      if vim.fn.executable('codebook-lsp') ~= 1 then
        vim.notify('codebook-lsp not found in PATH', vim.log.levels.WARN)
        return
      end

      -- Register and enable Codebook LSP using modern Neovim 0.11+ API
      vim.lsp.config('codebook', {
        cmd = { 'codebook-lsp', 'serve' },
        filetypes = {
          'markdown',
          'text',
          'gitcommit',
          'tex',
          'bib',
          'typst',
          'nix',
          'lua',
          'json',
          'yaml',
          'toml',
        },
        root_markers = { 'codebook.toml', '.git' },
        init_options = {
          logLevel = 'info',
          checkWhileTyping = true,
          diagnosticSeverity = 'information',
        },
      })

      -- Enable the LSP for current and future buffers
      vim.lsp.enable('codebook')
    '';

    # =============================================================================
    # User Commands
    # =============================================================================
    luaConfigRC.codebook-commands = ''
            -- Embedded preset configurations (provided by Nix at build time)
            local PRESET_EN = [==[
      ${enPreset}]==]

            local PRESET_NL = [==[
      ${nlPreset}]==]

            local PRESET_BOTH = [==[
      ${bothPreset}]==]

            -- Global config directory
            local config_dir = vim.fn.stdpath('config') .. '/codebook'
            local global_config_path = config_dir .. '/codebook.toml'

            -- Initialize global config directory and default config if needed
            local function ensure_global_config()
              -- Create config directory if it doesn't exist
              if vim.fn.isdirectory(config_dir) == 0 then
                vim.fn.mkdir(config_dir, 'p')
              end

              -- Write default English config if global config doesn't exist
              if vim.fn.filereadable(global_config_path) == 0 then
                local file = io.open(global_config_path, 'w')
                if file then
                  file:write(PRESET_EN)
                  file:close()
                  vim.notify('Created default global codebook config (English)', vim.log.levels.INFO)
                end
              end
            end

            -- Initialize on load
            ensure_global_config()

                  -- Helper function to restart Codebook LSP after config change
                  local function restart_codebook_lsp()
                    vim.notify('Restarting Codebook LSP...', vim.log.levels.INFO)

                    -- Get all codebook clients attached to buffers
                    local clients = vim.lsp.get_clients({ name = 'codebook' })

                    -- Store buffers that had codebook attached
                    local attached_buffers = {}
                    for _, client in ipairs(clients) do
                      for bufnr, _ in pairs(client.attached_buffers or {}) do
                        table.insert(attached_buffers, bufnr)
                      end
                    end

                    -- Store buffers that had codebook attached
                    local attached_buffers = {}
                    for _, client in ipairs(clients) do
                      for bufnr, _ in pairs(client.attached_buffers or {}) do
                        table.insert(attached_buffers, bufnr)
                      end
                    end

                    -- Stop all codebook clients
                    for _, client in ipairs(clients) do
                      client.stop()
                    end

                    -- Wait longer for cleanup and config reload, then restart
                    vim.defer_fn(function()
                      -- Re-enable will attach to current and future buffers
                      vim.lsp.enable('codebook')


                      -- Re-attach to previously attached buffers
                      for _, bufnr in ipairs(attached_buffers) do
                        if vim.api.nvim_buf_is_valid(bufnr) then
                          vim.lsp.buf_attach_client(bufnr, vim.lsp.get_clients({ name = 'codebook' })[1].id)
                        end
                      end


                      vim.notify('Codebook LSP restarted with new language config', vim.log.levels.INFO)
                    end, 800)
                  end

            -- Helper function to write a preset config
            -- Writes to global config by default, or project-local if requested
            local function write_config(preset_content, lang_name, use_local)
              local config_path

              if use_local then
                -- Write to project-local config
                config_path = vim.fn.getcwd() .. '/.codebook.toml'
                vim.notify('Writing ' .. lang_name .. ' config to project...', vim.log.levels.INFO)
              else
                -- Write to global config (default)
                config_path = global_config_path
                vim.notify('Writing ' .. lang_name .. ' config to global...', vim.log.levels.INFO)
              end

              local file, err = io.open(config_path, 'w')

              if not file then
                vim.notify(
                  'Failed to write codebook.toml: ' .. (err or 'unknown error'),
                  vim.log.levels.ERROR
                )
                return false
              end

              file:write(preset_content)
              file:close()
              -- Wait a moment to ensure file is written to disk
              vim.defer_fn(function() end, 100)

              return true
            end

        -- ========================================================================
        -- Spell checking commands
        -- ========================================================================

        -- Manual LSP attach command (for debugging)
        vim.api.nvim_create_user_command('CodebookAttach', function()
          vim.notify('Restarting Codebook LSP manually...', vim.log.levels.INFO)

          -- Get all codebook clients
          local clients = vim.lsp.get_clients({ name = 'codebook' })

          -- Stop all existing clients
          for _, client in ipairs(clients) do
            client.stop()
          end

          -- Re-enable after a longer delay
          vim.defer_fn(function()
            vim.lsp.enable('codebook')
            vim.notify('Codebook LSP restarted manually', vim.log.levels.INFO)
          end, 800)
        end, { desc = 'Manually restart Codebook LSP' })

        -- Add word to project dictionary via code action
        vim.api.nvim_create_user_command('SpellAdd', function()
          vim.lsp.buf.code_action({
            context = {
              diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }),
            },
            filter = function(action)
              return action.title and action.title:match('Add.*to dictionary')
            end,
            apply = true,
          })
        end, { desc = 'Add word to project dictionary' })

        -- Add word to global dictionary via code action
        vim.api.nvim_create_user_command('SpellAddGlobal', function()
          vim.lsp.buf.code_action({
            context = {
              diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 }),
            },
            filter = function(action)
              return action.title and action.title:match('Add.*to global dictionary')
            end,
            apply = true,
          })
        end, { desc = 'Add word to global dictionary' })

        -- Show spelling suggestions via code action
        vim.api.nvim_create_user_command('SpellSuggest', function()
          vim.lsp.buf.code_action()
        end, { desc = 'Show spelling suggestions' })

        -- Quick fix spelling (show all code actions for current word)
        vim.api.nvim_create_user_command('SpellFix', function()
          vim.lsp.buf.code_action()
        end, { desc = 'Show all spelling code actions' })

        -- ========================================================================
        -- Language switching commands
        -- ========================================================================

        -- Switch to English-only spell checking
        vim.api.nvim_create_user_command('SpellLangEn', function()
          if write_config(PRESET_EN, 'English', true) then
            restart_codebook_lsp()
          end
        end, { desc = 'Switch spell checking to English only' })

        -- Switch to Dutch-only spell checking
        vim.api.nvim_create_user_command('SpellLangNl', function()
          if write_config(PRESET_NL, 'Dutch', true) then
            restart_codebook_lsp()
          end
        end, { desc = 'Switch spell checking to Dutch only' })

        -- Switch to both languages
        vim.api.nvim_create_user_command('SpellLangBoth', function()
          if write_config(PRESET_BOTH, 'English + Dutch', true) then
            restart_codebook_lsp()
          end
        end, { desc = 'Switch spell checking to both English and Dutch' })

        -- Show current local config info
        vim.api.nvim_create_user_command('SpellLangStatus', function()
          local config_path = vim.fn.getcwd() .. '/.codebook.toml'

          -- Read the config file and check languages line
          local file = io.open(config_path, 'r')
          if not file then
            vim.notify('Cannot read .codebook.toml', vim.log.levels.WARN)
            return
          end

          local content = file:read('*all')
          file:close()

          -- Try to find the languages line
          local lang_line = content:match('dictionaries%s*=%s*%[([^%]]+)%]')
          if lang_line then
            vim.notify('Current spell check languages: ' .. lang_line, vim.log.levels.INFO)
          else
            vim.notify('Cannot determine language configuration', vim.log.levels.WARN)
          end

          -- Show attached clients
          local clients = vim.lsp.get_clients({ name = 'codebook', bufnr = 0 })
          if #clients > 0 then
            vim.notify('Codebook LSP is attached (client id: ' .. clients[1].id .. ')', vim.log.levels.INFO)
          else
            vim.notify('Codebook LSP is NOT attached to current buffer', vim.log.levels.WARN)
          end
        end, { desc = 'Show current spell checking language mode' })

        -- Show full codebook.toml content
        vim.api.nvim_create_user_command('SpellShowConfig', function()
          local config_path = vim.fn.getcwd() .. '/.codebook.toml'

          -- Read the config file
          local file = io.open(config_path, 'r')
          if not file then
            vim.notify('Cannot read codebook.toml', vim.log.levels.ERROR)
            return
          end

          local content = file:read('*all')
          file:close()

          -- Create a new buffer with the config content
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))
          vim.api.nvim_buf_set_option(buf, 'filetype', 'toml')
          vim.api.nvim_buf_set_option(buf, 'modifiable', false)

          -- Open in a split
          vim.cmd('split')
          vim.api.nvim_win_set_buf(0, buf)
          vim.api.nvim_buf_set_name(buf, 'codebook.toml (current)')
        end, { desc = 'Show full codebook.toml configuration' })

        -- Show codebook LSP client info
        vim.api.nvim_create_user_command('SpellLspInfo', function()
          local clients = vim.lsp.get_clients({ name = 'codebook' })

          if #clients == 0 then
            vim.notify('No Codebook LSP clients found', vim.log.levels.WARN)
            return
          end

          for _, client in ipairs(clients) do
            local attached_buffers = vim.tbl_keys(client.attached_buffers or {})
            local info = string.format(
              'Codebook LSP Client:\n' ..
              '  ID: %d\n' ..
              '  Name: %s\n' ..
              '  Root dir: %s\n' ..
              '  Attached buffers: %d\n' ..
              '  Status: %s',
              client.id,
              client.name,
              client.config.root_dir or 'N/A',
              #attached_buffers,
              client.is_stopped() and 'stopped' or 'running'
            )
            vim.notify(info, vim.log.levels.INFO)
          end
        end, { desc = 'Show Codebook LSP client information' })
    '';
  };
}
