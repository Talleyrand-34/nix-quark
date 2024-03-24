{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.quark;

in

{
  options.services.quark = {
    enable = mkEnableOption (lib.mdDoc "Simple webserver");

    port = mkOption {
      type = types.port;
      default = 80;
      description = lib.mdDoc "Port to run weebserver";
    };

    dir = mkOption {
      type = types.path;
      default = /var/www/html;
      description = lib.mdDoc "Directory to serve files";
    };
    openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the default ports in the firewall for the media server. The
          HTTP/HTTPS ports can be changed in the Web UI, so this option should
          only be used if they are unchanged.
        '';
      };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quark ];
    systemd.packages = [ pkgs.quark ];

    systemd.services.quark = {
      wantedBy = [ "multi-user.target" ];
    };
  };
};
