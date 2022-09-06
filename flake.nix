{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvim-parinfer = {
      url = "github:gpanders/nvim-parinfer";
      flake = false;
    };
    yuck-vim = {
      url = "github:elkowar/yuck.vim";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nvim-parinfer, yuck-vim }: 
    flake-utils.lib.eachDefaultSystem(system:
      let 
        pkgs = import nixpkgs {
          inherit system;
          overlays = [(final: prev: { 
              vimPlugins = prev.vimPlugins // {
                nvim-parinfer = prev.vimUtils.buildVimPlugin {
                  name = "nvim-parinfer";
                  src = inputs.nvim-parinfer;
                };
                yuck-vim = prev.vimUtils.buildVimPlugin {
                  name = "yuck-vim";
                  src = inputs.yuck-vim;
                };
              }; 
          })]; 
        };
      in {
        packages = {
          inherit (import ./neovim.nix { inherit pkgs; }) custom-neovim;
        };
        defaultPackage = self.packages.x86_64-linux.custom-neovim;
      });
}
