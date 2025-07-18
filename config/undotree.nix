{pkgs, ...}: {
  config.vim = {
    extraPlugins = with pkgs.vimPlugins; {
      undotree = {
        package = undotree;
        setup = ''
          vim.g.undotree_WindowLayout = 2
          vim.g.undotree_SplitWidth = 40
          vim.g.undotree_DiffpanelHeight = 10
          vim.g.undotree_SetFocusWhenToggle = 1
        '';
      };
    };

    keymaps = [
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>UndotreeToggle<CR>";
        silent = true;
        desc = "Toggle Undotree";
      }
    ];
  };
}
