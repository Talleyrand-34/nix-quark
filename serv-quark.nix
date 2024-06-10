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
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc ''Local url for the service. Don't touch unless if you use nginx unless you check.
      '';
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
    nginx = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to configure nginx as a reverse proxy for quark.

          It serves it under the domain specified in {option}`services.invidious.settings.domain` with enabled TLS and ACME.
          Further configuration can be done through {option}`services.nginx.virtualHosts.''${config.services.invidious.settings.domain}.*`,
          which can also be used to disable AMCE and TLS.
      '';
      };
      url= lib.mkOption {
        type = types.str;
        default = "localhost";
        description = "Url for nginx";
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quark ];
    systemd.packages = [ pkgs.quark ];

    systemd.services.quark = {
      description = "Quark Webserver";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.quark}/bin/quark -p ${toString cfg.port} -d ${cfg.dir} -h ${cfg.host}";
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.nginx.url} = {
        locations."/".proxyPass = "http://${cfg.host}:${toString cfg.port}";
        enableACME = lib.mkDefault true;
        forceSSL = lib.mkDefault true;
      };

  };
    networking.firewall.allowedTCPPorts =
      lib.optional (cfg.enable && cfg.openFirewall) cfg.port;
  };
}
