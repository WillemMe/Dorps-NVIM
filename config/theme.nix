{pkgs, ...}: let
  activeTheme = "tokyo-night-dark"; # keep in sync with home-dots stylix activeTheme

  # Parse the base16 YAML scheme file using IFD
  palette = let
    json = pkgs.runCommand "base16-scheme-json" {buildInputs = [pkgs.yq-go];} ''
      yq -o=json '.palette' ${pkgs.base16-schemes}/share/themes/${activeTheme}.yaml > $out
    '';
  in
    builtins.fromJSON (builtins.readFile json);
in {
  config.vim = {
    statusline = {
      lualine = {
        enable = true;
        theme = "base16";
        setupOpts = {
          options = {
            component_separators = {
              left = "";
              right = "";
            };
            section_separators = {
              left = "";
              right = "";
            };
            globalstatus = true;
          };
        };
      };
    };

    theme = {
      enable = true;
      name = "base16";
      transparent = true;
      base16-colors = palette;
    };
  };
}
