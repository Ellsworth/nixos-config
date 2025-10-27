{ config, pkgs, ... }:

{
  services.telegraf = {
    enable = true;

    # Optional: point Telegraf to a file that contains INFLUX_TOKEN=...
    environmentFiles = [ "/home/erich/nixos-config/.env" ];

    # Telegraf configuration (TOML) in-line.
    extraConfig = ''
      [agent]
        interval = "10s"
        round_interval = true
        flush_interval = "10s"
        metric_batch_size = 5000

      [global_tags]
        host = "${config.networking.hostName}"
        env  = "prod"

      [[inputs.cpu]]
        percpu = true
        totalcpu = true
        report_active = true
      [[inputs.mem]]
      [[inputs.swap]]
      [[inputs.disk]]
        ignore_fs = ["tmpfs","devtmpfs","devfs","overlay","aufs","squashfs"]
      [[inputs.diskio]]
      [[inputs.net]]
        interfaces = ["*"]
      [[inputs.processes]]
      [[inputs.system]]

      # InfluxDB 2.x / 3.x via v2 write API
      [[outputs.influxdb_v2]]
        urls = ["https://INFLUX_HOST:8086"]
        token = "$INFLUX_TOKEN"     # supplied via /run/secrets/influx.env
        organization = "YOUR_ORG"
        bucket = "system_metrics"

      # Example local downsampling (optional):
      # [[aggregators.basicstats]]
      #   period = "1m"
      #   drop_original = false
      #   stats = ["mean","min","max","stdev","sum","count"]
    '';
  };

  # Ensure Telegraf is started
  systemd.services.telegraf.wantedBy = [ "multi-user.target" ];
}
