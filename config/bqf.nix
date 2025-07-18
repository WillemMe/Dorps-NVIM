{pkgs, ...}: {
  config.vim = {
    extraPlugins = with pkgs.vimPlugins; {
      nvim-bqf = {
        package = nvim-bqf;
        # Basic setup, you can add more options here later if needed.
        # Refer to nvim-bqf documentation for available options.
        # Example: require('bqf').setup({ auto_resize_height = true, preview = { open_win_opts = { winblend = 0 } } })
        setup = "require('bqf').setup {}";
      };
    };

    # keymaps = [
    #   {
    #     mode = "n";
    #     key = "<leader>co"; # Example: toggle quickfix window
    #     action = "<cmd>copen<CR>";
    #     silent = true;
    #     desc = "Toggle Quickfix (enhanced by bqf)";
    #   }
    # ];
  };
}
