# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-22.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  # Mock the configuration for the quark service
  quarkServiceConfig = {
    services.quark = {
      enable = true;
      port = 8080; # Example of setting a custom port
      dir = "/var/www/html"; # Example of setting a custom directory
    };
  };

  # Import the serv-quark.nix module with the mock configuration
  quarkModule = import ./serv-quark.nix {
    config = quarkServiceConfig;
    lib = pkgs.lib;
    pkgs = pkgs;
  };

in
{
  quark = pkgs.callPackage ./quark.nix { };
  # How to call the module with the options? and pass the package above to the options module?
}
