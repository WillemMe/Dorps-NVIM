{lib, ...}: {
  config.vim = {
    ui = {
      noice = {
        enable = true;
        setupOpts = {
          cmdline = {view = "cmdline";};
          # Filter out lspconfig deprecation warnings
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "wmsg";
                any = [
                  {find = "lspconfig"}
                  {find = "deprecated"}
                ];
              };
              opts = {skip = true;};
            }
            {
              filter = {
                event = "notify";
                any = [
                  {find = "lspconfig"}
                  {find = "deprecated"}
                ];
              };
              opts = {skip = true;};
            }
          ];
        };
      };
    };
    keymaps = [
      {
        key = "<S-Enter>";
        action = lib.vim.raw ''
          function()
            require("noice").redirect(vim.fn.getcmdline())
          end
        '';
        mode = "c"; # Command-line mode
        silent = true;
        desc = "Redirect Cmdline";
      }
      {
        key = "<c-f>";
        action = lib.vim.raw ''
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end
        '';
        mode = ["n" "i" "s"]; # Normal, Insert, Select modes
        silent = true;
        expr = true;
        desc = "Scroll Noice LSP forward";
      }
      {
        key = "<c-b>";
        action = lib.vim.raw ''
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end
        '';
        mode = ["n" "i" "s"]; # Normal, Insert, Select modes
        silent = true;
        expr = true;
        desc = "Scroll Noice LSP backward";
      }
    ];
  };
}
