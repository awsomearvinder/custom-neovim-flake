{
  pkgs,
  ...
}: 
let
  compile-script = pkgs.writeScriptBin "compile-fennel-bin.sh" ''
  ${pkgs.fennel}/bin/fennel --compile $1 > ''${1%.fnl}.lua;
  rm $1
  '';
  dots = pkgs.stdenv.mkDerivation {
    name = "compiled-neovim-confs";
    src = ./dots;
    buildPhase = ''
    find -name "*.fnl" -exec ${compile-script}/bin/compile-fennel-bin.sh {} \;
    '';
    installPhase = ''
    mkdir -p $out/lib
    cp -r . $out/lib
    '';
  };
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  plugins = with pkgs.vimPlugins; [
    parinfer-rust
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
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
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
  custom-neovim-raw = pkgs.stdenv.mkDerivation {
    name = "nvim";
    unpackPhase = "true";
    buildInputs = [pkgs.makeWrapper pkgs.fzf pkgs.gh pkgs.git];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/nvim
      wrapProgram $out/bin/nvim \
        --add-flags "-u ${dots}/lib/nvim/init.lua" \
        --prefix XDG_CONFIG_DIRS : "${dots}/lib" \
        --set XDG_DATA_DIRS ${plugins-folder} \
        --prefix PATH : "${pkgs.fzf}/bin:${pkgs.gh}/bin"
    '';
  };
in {
  custom-neovim = pkgs.writeShellScriptBin "nvim"
    ''
      if [ "$1" == "cd" ]; then
        DIR="."
        if [ "$2" != "" ]; then
          DIR="$2"
        fi
        DIR=$(realpath -s $DIR)
        ${custom-neovim-raw}/bin/nvim --server "$NVIM" --remote-send "<C-\><C-n>:cd $DIR<CR>icd $DIR<CR>"
        exit 0
      fi

      if [ "$NVIM" != "" ]; then
        ${custom-neovim-raw}/bin/nvim --server "$NVIM" --remote-send "<C-\><C-n>:e $1<CR>"
      else
        ${custom-neovim-raw}/bin/nvim "$1"
      fi
    '';
}
