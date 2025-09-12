{ ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home-manager = { 
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jack = {
      home = {
        username = "jack"; 
        homeDirectory = "/home/jack";
        stateVersion = "25.05"; # Please read the comment before changing.
      };
      programs.home-manager.enable = true;
    };
  };
}
