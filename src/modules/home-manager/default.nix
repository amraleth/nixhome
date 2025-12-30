{ ... }:

{
  home.username = "amraleth";
  home.homeDirectory = "/home/amraleth";

  home.stateVersion = "24.05";

  imports = [
    ./editors
    ./tools
 #   ./wm/sway.nix
    ./wm/i3.nix
  ];
  
}
