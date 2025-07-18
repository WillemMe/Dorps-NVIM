{pkgs, ...}: {
  config.vim = {
    extraPlugins = with pkgs.vimPlugins; {
      harpoon = {
        package = harpoon;
        setup = "require('harpoon').setup {}";
      };
    };

    keymaps = [
      {
        key = "<leader>a";
        mode = "n";
        action = "<cmd>lua require('harpoon.mark').add_file()<CR>";
        silent = true;
        desc = "Harpoon: Add file";
      }
      {
        key = "<C-e>";
        mode = "n";
        action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>";
        silent = true;
        desc = "Harpoon: Toggle menu";
      }
      {
        key = "<C-h>";
        mode = "n";
        action = "<cmd>lua require('harpoon.ui').nav_file(1)<CR>";
        silent = true;
        desc = "Harpoon: Navigate to file 1";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<cmd>lua require('harpoon.ui').nav_file(2)<CR>";
        silent = true;
        desc = "Harpoon: Navigate to file 2";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<cmd>lua require('harpoon.ui').nav_file(3)<CR>";
        silent = true;
        desc = "Harpoon: Navigate to file 3";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<cmd>lua require('harpoon.ui').nav_file(4)<CR>";
        silent = true;
        desc = "Harpoon: Navigate to file 4";
      }
    ];
  };
}
