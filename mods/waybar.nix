{ ... }:
{
  home-manager.users.jack.programs.waybar = {
    enable = true;
    settings.main = {
      modules-left = [
        "cpu"
        "memory"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "battery"
        "wireplumber#sink"
        "network"
      ];
      layer = "top";
      position = "top";
      cpu = {
        format = "  {usage}%";
        interval = 2;
        states.critical = 90;
      };
      memory = {
        format = "  {percentage}%";
        interval = 2;
        states.critical = 75;
      };
      clock = {
        format = "{:%H:%M - %a, %d %b}";
        tooltip = false;
      };
      battery = {
        states = {
            warning = 30;
            critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = ["󰁺" "󰁺" "󰁽" "󰂀" "󰁹"];
      };
      "wireplumber#sink" = {
       format = "{volume}% {icon}";
       format-muted = "󰝟";
       format-icons = ["" "" ""];
       on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
       scroll-step = 5;
      };
      network = {
        interval = 1000;
        format-wifi = "{icon}";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{essid}\n{ifname} via {gwaddr}\n{ipaddr}/{cidr}";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "󰤭";
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
      };
    };
  };
}
