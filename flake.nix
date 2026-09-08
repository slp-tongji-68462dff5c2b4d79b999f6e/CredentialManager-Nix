{
  description = "CredentialManager — OIDC login + self-managed downstream credentials web service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.callPackage ./package.nix { };
        }
      );

      nixosModules.default =
        { config, lib, pkgs, ... }:
        import ./module.nix {
          inherit config lib pkgs;
          defaultPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
    };
}
