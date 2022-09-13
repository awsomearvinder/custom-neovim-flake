{
  pkgs,
  ...
}: 
let
  dots = ./dots;
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  gh-local = pkgs.stdenv.mkDerivation {
    name = "local-gh";
    buildInputs = [pkgs.makeWrapper];
    #TODO: FIX.
    buildCommand = ''
      mkdir -p $out/bin
      ln -s ${pkgs.gh}/bin/gh $out/bin/gh
      wrapProgram $out/bin/gh --set GH_CONFIG_DIR '/home/bender/.config/gh'
    '';
  };
  plugins = with pkgs.vimPlugins; [
    nvim-parinfer
    yuck-vim
    auto-pairs
    nvim-ts-autotag
    vim-highlightedyank
    vim-rooter
    gruvbox-nvim
    yats-vim
    vim-gitgutter
    vimtex
    vim-sensible
    vim-nix
    (nvim-treesitter.withPlugins (p: builtins.attrValues p))
    nvim-lspconfig
    telescope-nvim
    plenary-nvim
    telescope-ui-select-nvim
    nerdtree
    neoformat
    orgmode
    luasnip
    which-key-nvim
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    octo-nvim
    nvim-web-devicons
    git-conflict
  ];
  plugins-folder = pkgs.stdenv.mkDerivation {
    name = "neovim-plugins";
    buildCommand = ''
      mkdir -p $out/nvim/site/pack/plugins/start/
      ${pkgs.lib.concatMapStringsSep "\n" (path: "ln -s ${path} $out/nvim/site/pack/plugins/start/")  plugins }
      '';
  };
in {
  custom-neovim = pkgs.stdenv.mkDerivation {
    name = "nvim";
    unpackPhase = "true";
    buildInputs = [pkgs.makeWrapper pkgs.fzf gh-local pkgs.git];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/nvim
      wrapProgram $out/bin/nvim --set XDG_CONFIG_HOME ${dots} \
        --set XDG_DATA_DIRS ${plugins-folder} \
        --prefix PATH : "${pkgs.fzf}/bin:${gh-local}/bin"
    '';
  };
}
