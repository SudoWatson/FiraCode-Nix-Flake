{
  description = "Fira Code with configurable stylistic sets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosModules.firaCodeCustom = import ./modules/fira-code-custom.nix;

    packages.${system}.fira-code-custom =
      pkgs.callPackage ./pkgs/fira-code-custom.nix { };
  };
}
