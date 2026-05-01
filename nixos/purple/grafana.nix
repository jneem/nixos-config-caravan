# grafana.nix
{ config, pkgs, ... }:

{
    # TODO: configure users
    services.grafana = {
        enable = true;
        openFirewall = true;
        settings = {
            server = {
                # TODO: consider putting this behind a proxy
                http_addr = "0.0.0.0";
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
