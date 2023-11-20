{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-pre-commit = {
      url = "github:kingarrrt/nix-pre-commit";
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
              name = "ruff check";
              package = ruff;
              # ERA001: catch commented-out code - here because we don't want it for normal dev
              # ISC001: check for implicitly concatenated strings - disabled for format
              args = ["check" "--fix" "--extend-select=ERA001,ISC001" "--unfixable=ERA001"];
              types_or = ["python" "pyi"];
            }
            {
              name = "ruff format";
              package = ruff;
              args = ["format"];
              types_or = ["python" "pyi"];
            }
            {
              name = "mypy";
              package = gnumake;
              types_or = ["python" "pyi"];
              args = ["mypy"];
              pass_filenames = false;
            }
            {
              entry = "vulture";
              args = ["."];
              types_or = ["python" "pyi"];
              pass_filenames = false;
            }
            # sh
            {
              package = shfmt;
              args = ["-w"];
              types = ["shell"];
            }
            # yaml
            {
              entry = "yamlfix";
              args = ["--exclude=.pre-commit-config.yaml" "."];
              types = ["yaml"];
            }
            {
              entry = "yamllint";
              args = ["."];
              types = ["yaml"];
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
