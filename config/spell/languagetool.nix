{pkgs, ...}: let
  jar = "${pkgs.languagetool}/share/languagetool-commandline.jar";
in {
  config.vim = {
    extraPackages = [pkgs.languagetool];

    extraPlugins = {
      vim-LanguageTool = {
        package = pkgs.vimPlugins.vim-LanguageTool;
      };
    };

    luaConfigRC.languagetool = ''
      vim.cmd([[
        let g:languagetool_jar = '${jar}'
        let g:languagetool_lang = 'en-US'
      ]])
    '';
  };
}
