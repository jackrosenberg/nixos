let
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0FUN22vJEZ5ByeUms4KvXfYe9g4UnAlaVMmhr5cO8/";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKRegupPNZScgm0WszmUGt3H4o3S1SIUUX8zjjRmC6pp";
in
{
  "rcloneConf.age".publicKeys = [ laptop server ];
  "resticPDrivePass.age".publicKeys = [ laptop server ];
  "transmissionCreds.age".publicKeys = [ laptop server ];
  "healthchecksSettings.age".publicKeys = [ laptop server ];
  "newtConf.age".publicKeys = [ laptop server ];
  "lasuite.age".publicKeys = [ laptop server ];
  "garageRpcSecret.age".publicKeys = [ laptop server ];
  "garageAdminToken.age".publicKeys = [ laptop server ];
  "gitlab.age".publicKeys = [ laptop server ];
  "vpn.ovpn.age".publicKeys = [ laptop server ];
  "vpn-auth-user-pass.age".publicKeys = [ laptop server ];
  "dexsecret.age".publicKeys = [ laptop server ];
}
