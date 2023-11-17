{
  inputs = {
    nixpkgs.url = "/home/arthur/wrk/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-pre-commit = {
      url = "/home/arthur/wrk/nix-pre-commit";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        default = pkgs.callPackage ./default.nix {};
      in {
        packages.default = default;
        checks.default = default.overrideAttrs (_pkg: {
          checkPhase = ''
            HOME=$(mktemp -d) make lint test-unit
          '';
          doCheck = true;
        });
        # devShells.default = pkgs.mkShell {
        #   name = "dev";
        #   buildInputs = with pkgs; [cachix gitMinimal];
        #   inputsFrom = builtins.attrValues self.packages.${system};
        # };
        devShells.default = with pkgs; let
          pre-commit = inputs.nix-pre-commit.lib.${system}.mkLocalConfig [
            # nix
            {
              package = deadnix;
              args = ["--edit"];
              types = ["nix"];
            }
            {
              package = statix;
              args = ["fix"];
              pass_filenames = false;
              types = ["nix"];
            }
            {
              package = alejandra;
              args = ["--quiet"];
              types = ["nix"];
            }
            # py
            {
              package = ruff;
              args = ["check" "--fix"];
              types_or = ["python" "pyi"];
            }
            # sh
            {
              package = beautysh;
              types = ["shell"];
            }
          ];
        in
          pkgs.mkShell {
            inherit (pre-commit) shellHook;
            inputsFrom = builtins.attrValues self.packages.${system};
            packages =
              pre-commit.packages
              ++ [
                cachix
                gitMinimal
              ];
          };

        formatter = pkgs.alejandra;
      }
    );
}
