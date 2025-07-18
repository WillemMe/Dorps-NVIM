{pkgs, ...}: {
  config.vim = {
    # vim-tmux-navigator allows seamless navigation between Neovim splits and Tmux panes.
    # It typically uses Ctrl-h/j/k/l for navigation.
    # No specific setup function is usually required for basic functionality.
    extraPlugins = with pkgs.vimPlugins; {
      vim-tmux-navigator = {
        package = vim-tmux-navigator;
      };
    };
  };
}
