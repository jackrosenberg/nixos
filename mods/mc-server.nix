{ pkgs, ...}:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.minecraftServers.vanilla-1-20;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    serverProperties = {
      server-port = 25565;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "NixOS Minecraft server!";
      white-list = false;
      allow-cheats = true;
    };
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
  };
}
