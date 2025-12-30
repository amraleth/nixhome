{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      key = "AB4DD22935428E2F";
      signByDefault = true;
    };
    settings = {
      init.defaultBranch = "stable";
      core.editor = "vim";
      user = {
        email = "patrick@vollandt.dev";
        name = "Patrick Vollandt";
      };
    };
  };
}
