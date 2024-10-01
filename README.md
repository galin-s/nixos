# nixos

Steps to reproduce:


1. add nix.settings.experimental-features = [ "nix-command" "flakes" ]; to ~/.config/nix/nix.conf
2. execute 
   nixos-rebuild switch

3. execute
   nix flake init

4. config flake.nix - add git, wget, nixops, etc..
5. execute
   nix develop

6. add the Prometheus, Prometheus Node Exporter and Grafana settings - /etc/nixos/configuration.nix
7. mkdir /etc/grafana-dashboards
8. chmod 777 /etc/grafana-dashboards
9. mv cpu_memory_disk.json to /etc/grafana-dashboards

10. execute
    nixos-rebuild switch

11. to build the VM execute
    nixos-rebuild build-vm --flake .#test
12. to start the VM execute
    result/bin/run-nixos-vm

