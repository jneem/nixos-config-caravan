# grafana.nix
{ config, pkgs, ... }:

{
    services.caddy = {
        enable = true;
        virtualHosts."http://grafana.treeman" = {
            extraConfig = ''
                bind 10.67.67.3
                reverse_proxy http://localhost:2345
            '';
        };
    };
    services.grafana = {
        enable = true;
        settings = {
            server = {
                http_addr = "127.0.0.1";
                http_port = 2345; # default: 3000
                enable_gzip = true;
            };
            #security.admin_email = systemSettings.extraSettings.email;
            analytics.reporting_enabled = false;
            # TODO: we don't have anything secret in the database, but
            # we could be more secure about this anyway...
            security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
        };

        provision = {
            # dashboards.settings.providers = [
            #     { name = "Overview"; options.path = "/etc/grafana-dashboards"; }
            # ];

            datasources.settings = {
                apiVersion = 1;
                datasources = [
                    {
                        name = "VictoriaMetrics";
                        type = "victoriametrics-metrics-datasource";
                        access = "proxy";
                        url = "http://127.0.0.1:8428";
                        isDefault = true;
                    }

                    {
                        name = "VictoriaLogs";
                        type = "victoriametrics-logs-datasource";
                        access = "proxy";
                        url = "http://127.0.0.1:9428";
                        isDefault = false;
                    }
                ];
            };
        };

        declarativePlugins = with pkgs.grafanaPlugins; [
            victoriametrics-metrics-datasource
            victoriametrics-logs-datasource
        ];
    };
}
