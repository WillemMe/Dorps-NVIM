{pkgs, ...}: {
  config.vim = {
    extraPackages = with pkgs; [typst typstyle tinymist newcomputermodern];
    languages.typst = {
      enable = true;
      lsp = {
        enable = true;
      };
      format.type = "typstyle";
      extensions = {
        typst-preview-nvim.enable = true;
      };
    };
  };
}
