{ ... }:

{
  security.polkit.enable = true;

  security.pam.services = {
    i3lock.enable = true;
    i3lock-color.enable = true;
    xlock.enable = true;
    xscreensaver.enable = true;
  };
}
