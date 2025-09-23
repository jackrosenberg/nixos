{
  inputs,
  pkgs,
  lib,
  ...
}:
# let
# in
{
  imports = [ ./hyprlock.nix ];
  environment.systemPackages = with pkgs; [
    hyprlock
    nwg-look
    grim
    slurp
    wl-clipboard-rs
    libnotify
  ];
  # jazz this hoe up, this is 8GB total, so watch out
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    thunar.enable = true;
  };

  home-manager.users.jack = {
    programs = {
      rofi.enable = true;
      waybar = {
        enable = true;
        settings.main = {
          modules-left = [
            "cpu"
            "memory"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "battery"
            "volume"
            "network"
          ];
          layer = "top";
          position = "top";
          cpu = {
            format = "cpu {usage}%";
            interval = 2;
            states.critical = 90;
          };
          memory = {
            format = "mem {percentage}%";
            interval = 2;
            states.critical = 75;
          };
          clock = {
            format = "{:%H:%M - %a, %d %b}";
            tooltip = false;
          };
          network = {
            interval = 1000;
            format-wifi = "{icon}";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{essid}\n{ifname} via {gwaddr}\n{ipaddr}/{cidr}";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "󰤭";
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
          };
        };
      };
    };
    # notifications
    services.swaync = {
      enable = true;
    };
    # make pointer normal
    home.file.".icons/default".source = "${pkgs.hackneyed}/share/icons/";
    wayland.windowManager = { 
      hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "waybar"
          ];
          # once on boot
          execr-once = [
            "hyprctl setcursor Adwaita 18" # unfuck cursor
          ];
          general = {
            resize_on_border = true; # allow mouse resize
          };
          decoration = {
            rounding = 5;
            active_opacity = 1;
            inactive_opacity = .9;
            fullscreen_opacity = 1;
            dim_inactive = true;
            dim_strength = .1;
            dim_special = .8;
          };
          input = {
            touchpad = {
              natural_scroll = true; # invert
            };
            repeat_delay = 300;
            repeat_rate = 50;
          };
          # keybinds
          bind = [
            "SUPER, Return, exec, kitty"
            "SUPER, Q, forcekillactive,"
            "SUPER, D, exec, rofi -show drun"
            "SUPER, T, exec, thunar"
            "ALT, TAB, cyclenext"
            "SUPER, TAB, workspace, e+1" # cycle
          ]
            # soemtimes, my genius, it scares me
          ++ lib.mapCartesianProduct({ n,cmd }: "SUPER ${lib.optionalString (cmd != "workspace") "SHIFT"}, ${toString n}, ${cmd}, ${toString n}") {
            n = lib.range 1 5;
            cmd = [
              "workspace"
              "movetoworkspacesilent"
            ];
          };
          binds.drag_threshold = 10; # only treat as drag after 10px
          bindm = [
            "SUPER, mouse:272, movewindow"
          ];
          # TODO NOTIFY SEND
          binde = [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
          gestures.gesture = "3, horizontal, workspace";
          # place any monitor above default
          monitor = [
            ", preferred, auto, auto"
            ", preferred, auto-up, auto"
          ];
        };
      };
    };
  };
}
