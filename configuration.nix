{ config, pkgs, ... }:

{
  imports = [
#    ./hardware-configuration.nix
#    ./default.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Sofia";

  i18n.defaultLocale = "en_US.UTF-8";

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024 * 1024 * 1024;
    }
  ];

  #services.openssh = {
  #  enable = true;
  #  hostKeys = options.services.openssh.hostKeys.default;
  #  services.openssh = {
  #    settings.PasswordAuthentication = true;
  #    extraConfig = "Port 22";
  #  };
  #};

  services.prometheus = {
    enable = true;
    port = 9090;
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
      {
        job_name = "node_exporter";
        static_configs = [
          {
             targets = ["127.0.0.1:9100"];
          }
        ];
      }
    ];
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [
      "cpu"
      "meminfo"
      "diskstats"
      "filesystem"
      "loadavg"
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        domain = "127.0.0.1";
        protocol = "http";
      };
    };
    dataDir = "/var/lib/grafana";
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          isDefault = true;
        }
      ];
      dashboards.settings.providers = [
        {   
          name = "Galin Dashboards";
          options.path = "/etc/grafana-dashboards";
        }
      ];
    };
  };

  systemd.services.prometheus.serviceConfig = {
    MemoryMax = "128M";
  };

  systemd.services.grafana.serviceConfig = {
    MemoryMax = "128M";
  };

  boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.kernel.sysctl = {
    "vm.overcommit_memory" = 2;
    "vm.overcommit_ratio" = 50;
  };

  environment.etc."grafana-dashboards".text = "";

  fileSystems."/etc/grafana-dashboards" = {
    device = "./cpu_memory_disk.json";
    fsType = "none";
    options = [ "bind" ];
  };
  
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 1024;
      cores = 1;
      graphics = false;
    };
  };

  environment.systemPackages = with pkgs; [
      git
      htop
      vim
      curl
      wget
  ];   
  networking.firewall.allowedTCPPorts = [ 9090 9100 3000 22 ];
 
  users.groups.admin = {};
  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "wheel" ];
    password = "admin";
    group = "admin";
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "admin";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
