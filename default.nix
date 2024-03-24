# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-22.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  quark = pkgs.callPackage ./quark.nix { };
  # How to call the module with the options? and pass the package above to the options module?
}
