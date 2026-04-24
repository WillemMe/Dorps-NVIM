# LTeX-ls Configuration
# Grammar and style checking via LanguageTool, integrated as an LSP server
{pkgs, ...}: {
  config.vim = {
    extraPackages = [pkgs.ltex-ls];

    luaConfigRC.ltex-ls = ''
      -- Guard: Ensure ltex-ls is available in PATH
      if vim.fn.executable('ltex-ls') ~= 1 then
        vim.notify('ltex-ls not found in PATH', vim.log.levels.WARN)
        return
      end

      -- Register LTeX LSP using Neovim 0.11+ API
      vim.lsp.config('ltex', {
        cmd = { 'ltex-ls' },
        filetypes = {
          'markdown',
          'text',
          'gitcommit',
          'tex',
          'bib',
          'typst',
          'rst',
          'org',
        },
        root_markers = { '.git' },
        settings = {
          ltex = {
            language = 'en-US',
            checkFrequency = 'save',
            logLevel = 'config',
            additionalRules = {
                motherTongue = 'nl',
                enablePickyRules = true,
            },
          },
        },
      })

      vim.lsp.enable('ltex')

      -- Switch ltex language at runtime
      local function ltex_set_language(lang)
        local clients = vim.lsp.get_clients({ name = 'ltex' })
        if #clients == 0 then
          vim.notify('ltex not running', vim.log.levels.WARN)
          return
        end
        for _, client in ipairs(clients) do
          client.config.settings.ltex = vim.tbl_deep_extend('force', client.config.settings.ltex or {}, {
            language = lang,
          })
          client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
          -- Re-check the current buffer immediately after switching language
          local bufnr = vim.api.nvim_get_current_buf()
          local uri = vim.uri_from_bufnr(bufnr)
          client.request('workspace/executeCommand', {
            command = '_ltex.checkDocument',
            arguments = { { uri = uri } },
          }, nil, bufnr)
        end
        vim.notify('ltex language set to ' .. lang, vim.log.levels.INFO)
      end

      vim.api.nvim_create_user_command('LtexLangEn', function() ltex_set_language('en-US') end, { desc = 'Set ltex language to English' })
      vim.api.nvim_create_user_command('LtexLangNl', function() ltex_set_language('nl') end, { desc = 'Set ltex language to Dutch' })

      -- Suppress all ltex messages at the LSP handler level
      local function is_ltex(ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        return client and client.name == 'ltex'
      end

      local orig_progress = vim.lsp.handlers['$/progress']
      vim.lsp.handlers['$/progress'] = function(err, result, ctx, config)
        if is_ltex(ctx) then return end
        if orig_progress then orig_progress(err, result, ctx, config) end
      end

      local orig_show = vim.lsp.handlers['window/showMessage']
      vim.lsp.handlers['window/showMessage'] = function(err, result, ctx, config)
        if is_ltex(ctx) then return end
        if orig_show then orig_show(err, result, ctx, config) end
      end

      local orig_log = vim.lsp.handlers['window/logMessage']
      vim.lsp.handlers['window/logMessage'] = function(err, result, ctx, config)
        if is_ltex(ctx) then return end
        if orig_log then orig_log(err, result, ctx, config) end
      end
    '';
  };
}
