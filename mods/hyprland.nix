{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    hyprlock
    nwg-look
    grim
    slurp
    wl-clipboard-rs
  ];
  programs.hyprland = {
    enable = true;
    # set the flake package
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  programs.thunar.enable = true;
}
