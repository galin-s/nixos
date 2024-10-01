{ pkgs ? import <nixpkgs> {} }:

{
  nixosConfigurations = {
    TestNixOS = pkgs.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
