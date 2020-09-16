let
  pkgs = import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
      (import ./overrides.nix)
    ];
  };
in
pkgs.grahamc.portable-shell
