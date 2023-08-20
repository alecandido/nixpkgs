{ pkgs, lib, ... }:

{
  home.packages = with pkgs;
    [
      # Some basics
      coreutils
      curl
      wget

      # Tools
      exa
      jq
      ripgrep
      fd
      # ripgrep-all
      duf
      gh
      ncdu_1
      fzf
    ] ++ lib.optionals stdenv.isDarwin [ m-cli ];

  # XDG
  xdg.enable = true;

  # Starship
  programs.starship = {
    enable = true;
    settings = { hostname.ssh_only = false; package.disabled = true; };
  };

  # Atuin
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Htop
  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };
}
