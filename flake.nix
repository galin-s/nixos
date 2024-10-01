{
  description = "Task flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      devShells.${system}.default = 
        pkgs.mkShell {
          buildInputs = [
            pkgs.git
            pkgs.htop
            pkgs.vim
            pkgs.curl
            pkgs.wget
         ];
      };
 
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
   };
}
