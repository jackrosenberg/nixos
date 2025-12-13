{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unityhub
    vscode.fhs # barf
    dotnetCorePackages.sdk_9_0-bin
    esp-generate
    espflash
    espup
  ];

  environment.sessionVariables = {
    PATH = "/home/jack/.rustup/toolchains/esp/xtensa-esp-elf/esp-15.2.0_20250920/xtensa-esp-elf/bin:$PATH";
    LIBCLANG_PATH = "/home/jack/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-20.1.1_20250829/esp-clang/lib";
  };
  # ## USB protocol foxfit
  users = {
    users.jack.extraGroups = [
      "plugdev"
      "uucp"
      "dialout"
    ];
    groups.plugdev = { };
    groups.uucp = { };
    groups.dialout = { };
  };
}
