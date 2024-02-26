{ config, ... }:
let
  xdg = config.xdg;
in
{
  home.shellAliases = {
    ls = "eza";
    la = "ls -a";
    ll = "ls -l";
    nv = "nvim";
    py = "python";
    ipy = "ipython";
    rename = "rnr";
    develop = "nix develop ${xdg.configHome}/nixpkgs -c $SHELL";
    dev-flake = ''
      nix flake init --template github:cachix/devenv
    '';
    kcern = ''
      echo $(rbw get CERN) | kinit candidal@CERN.CH
    '';
  };
}
