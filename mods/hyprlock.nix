{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    hyprlock
  ];
  # fingerprint
  services.fprintd.enable = true;
  security.pam.services.hyprlock = {
    fprintAuth = true;
  };

  home-manager.users.jack = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          disable_loading_bar = true;
        };
        input-field = [
          {
            monitor = "";
            size = "250, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.5)";
            font_color = "rgb(200, 200, 200)";
            fade_on_empty = false;
            placeholder_text = ''<i><span foreground="##bd93f9">Input Password...</span></i>'';
            hide_input = false;
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 120;
            position = "0, 80";
            valign = "center";
            halign = "center";
          }
        ];
      };
    };
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, L, exec, hyprlock"
    ];
  };
}
