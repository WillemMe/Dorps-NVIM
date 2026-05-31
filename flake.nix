{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in {
    packages = forEachSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      configModule = import ./config;

      # Evaluate any and all modules to create the wrapped Neovim package.
      neovimConfigured = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;

        modules = [configModule];
      };
    in {
      neovim = neovimConfigured.neovim;
      default = self.packages.${system}.neovim;
    });
  };
}
