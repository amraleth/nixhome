{ pkgs,  ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  home.file.".config/emacs".source = ./emacs-config;

  home.packages = with pkgs; [
    cmake
    gnumake
    nerd-fonts.jetbrains-mono
    gcc
    libtool
    nixd
  ];
}
