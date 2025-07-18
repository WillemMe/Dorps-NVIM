{pkgs, ...}: {
  config.vim = {
    # Ensure the zoxide command-line tool is available to Neovim.
    # NVF will make this available in Neovim's PATH.
    extraPackages = [pkgs.zoxide];

    extraPlugins = with pkgs.vimPlugins; {
      telescope-zoxide = {
        package = telescope-zoxide;
        # Basic setup for telescope-zoxide
        setup = "require('telescope').load_extension('zoxide')";
      };
    };
    # Keymap to open the Telescope zoxide picker.
    # The telescope-zoxide-nvim plugin itself is enabled via
    # config.vim.telescope.extensions.zoxide.enable = true in default.nix.
    keymaps = [
      {
        mode = "n";
        key = "<leader>fz"; # "Find Zoxide" (mnemonic: Find directory via Zoxide)
        action = "<cmd>lua require('telescope').extensions.zoxide.list()<CR>";
        silent = true;
        desc = "Find directory (Zoxide)";
      }
    ];
  };
}
