let
  pkgs = import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
    ] ++ (if builtins.pathExists ./overrides.nix
    then [ (import ./overrides.nix) ]
    else [ ]);
  };
in
pkgs.grahamc.portable-shell
