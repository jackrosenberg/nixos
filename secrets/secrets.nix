let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0FUN22vJEZ5ByeUms4KvXfYe9g4UnAlaVMmhr5cO8/";
  users = [ user1 ];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0FUN22vJEZ5ByeUms4KvXfYe9g4UnAlaVMmhr5cO8/";
  systems = [ system1 ];
in
{
  "rcloneConf.age".publicKeys = [ user1 system1 ];
  "resticPDrivePass.age".publicKeys = [ user1 system1 ];
  "transmissionCreds.age".publicKeys = [ user1 system1 ];}

