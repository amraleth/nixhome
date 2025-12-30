{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    settings.use-keyboxd = false;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
