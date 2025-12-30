{ pkgs, ... }:

{
	imports =[
		./hardware/prometheus.nix
		../modules
		#../modules/nixos/wm/gnome.nix

		<home-manager/nixos>
	];

	networking.hostName = "prometheus"; 

	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
		vim
		tree
	];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.amraleth = import ../modules/home-manager;

	system.stateVersion = "25.11"; 
}
