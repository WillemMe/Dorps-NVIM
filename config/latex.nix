{pkgs, ...}: {
  config.vim = {
    extraPackages = with pkgs; [texpresso texlab texliveMedium];
    extraPlugins = {
      "texpresso.vim" = {
        package = pkgs.vimPlugins.texpresso-vim;
      };
    };
    # languages.latex = {
    #   lsp = {
    #     enable = true;
    #     pacakge = ["texlab"];
    #   };
    # };
  };
}
