let
  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0FUN22vJEZ5ByeUms4KvXfYe9g4UnAlaVMmhr5cO8/";
in
{
  "rcloneConf.age".publicKeys = [ system1 ];
  "resticPDrivePass.age".publicKeys = [ system1 ];
  "transmissionCreds.age".publicKeys = [ system1 ];
  "healthchecksSettings.age".publicKeys = [ system1 ];
  "newtConf.age".publicKeys = [ system1 ];
  "lasuite.age".publicKeys = [ system1 ];
  "garageRpcSecret.age".publicKeys = [ system1 ];
  "garageAdminToken.age".publicKeys = [ system1 ];
  "gitlab.age".publicKeys = [ system1 ];
}
