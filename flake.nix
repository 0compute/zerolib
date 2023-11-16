{
  inputs = {
    nixpkgs.url = "/home/arthur/wrk/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        default = pkgs.callPackage ./default.nix {};
      in {
        packages.default = default;
        checks.default = default.overrideAttrs (_pkg: {
          checkPhase = ''
            HOME=$(mktemp -d) make lint test-unit
          '';
          doCheck = true;
        });
        devShells.default = pkgs.mkShell {
          name = "dev";
          buildInputs = with pkgs; [cachix gitMinimal];
          inputsFrom = builtins.attrValues self.packages.${system};
        };
      }
    );
}
