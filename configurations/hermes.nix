{ pkgs, ... }:
{
  imports = [
    ../mods/bluetooth.nix
    ../mods/udisk.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.systemPackages = with pkgs; [
    unityhub
    vscode.fhs # barf
    dotnetCorePackages.sdk_9_0-bin
    meld
    # citrix_workspace
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
    ghc
    haskell.compiler.native-bignum.ghcHEAD
    # haskellPackages.base_4_21_0_0
    # foxfit
    esp-generate
    espflash
    espup
    # probe-rs
  ];
  # nixpkgs.config.allowBroken = true;
  services.fprintd.enable = true;
  programs = {
    steam.enable = true;
    nix-ld.enable = true;
  };
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
  #
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", MODE="0660", GROUP="plugdev"
  # '';
}
