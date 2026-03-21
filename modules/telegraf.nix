{
  config,
  pkgs,
  lib,
  ...
}:

{

  systemd.services.telegraf.path = [
    "/run/wrappers"
    pkgs.smartmontools
    pkgs.nvme-cli
  ];

  services.telegraf = {
    enable = true;

    # Token and other secrets loaded from .env
    environmentFiles = [ "/home/erich/nixos-config/.env" ];

    extraConfig = {
      agent = {
        interval = "300s";
        round_interval = true;
        flush_interval = "10s";
        metric_batch_size = 1000;
      };

      global_tags = {
        host = config.networking.hostName;
        env = "prod";
      };

      inputs = {
        cpu = [
          {
            percpu = true;
            totalcpu = true;
            report_active = true;
          }
        ];

        # Battery Monitoring (Numeric)
        file = [
          {
            files = [
              "/sys/class/power_supply/BAT1/capacity"
              "/sys/class/power_supply/BAT1/charge_now"
              "/sys/class/power_supply/BAT1/charge_full"
              "/sys/class/power_supply/BAT1/current_now"
              "/sys/class/power_supply/BAT1/voltage_now"
              "/sys/class/power_supply/BAT1/cycle_count"
            ];
            data_format = "value";
            data_type = "integer";
            name_override = "battery_stats";
            tags = {
              battery = "BAT1";
            };
          }
          # Battery Monitoring (Strings)
          {
            files = [
              "/sys/class/power_supply/BAT1/status"
              "/sys/class/power_supply/BAT1/capacity_level"
            ];
            data_format = "value";
            data_type = "string";
            name_override = "battery_info";
            tags = {
              battery = "BAT1";
            };
          }
        ];

        # Enable SMART monitoring (NVMe + SATA)
        smart = [
          {
            path_smartctl = "/run/current-system/sw/bin/smartctl";
            path_nvme = "/run/current-system/sw/bin/nvme";
            enable_extensions = [ "auto-on" ];
            use_sudo = true;
            interval = "300s";
            attributes = true;
          }
        ];
      };

      outputs = {
        influxdb_v2 = [
          {
            urls = [ "$INFLUX_HOST" ];
            token = "$INFLUX_TOKEN";
            organization = "default";
            bucket = "telegraf";
          }
        ];
      };
    };
  };

  # Allow Telegraf to run smartctl without a password
  security.sudo.extraRules = [
    {
      users = [ "telegraf" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/smartctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Ensure Telegraf is started
  systemd.services.telegraf.wantedBy = [ "multi-user.target" ];
}
