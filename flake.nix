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

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in
      rec {

        devShells.default =
          with pkgs;
          with python3Packages;
          let
            pre-commit =
              let
                py =
                  attrs:
                  attrs
                  // {
                    types_or = [
                      "python"
                      "pyi"
                    ];
                  };
              in
              inputs.nix-pre-commit.lib.${system}.mkLocalConfig [
                # nix
                {
                  package = formatter;
                  types = [ "nix" ];
                }
                {
                  package = deadnix;
                  args = [ "--edit" ];
                  types = [ "nix" ];
                }
                {
                  package = statix;
                  args = [ "fix" ];
                  pass_filenames = false;
                  types = [ "nix" ];
                }
                # py
                (py {
                  name = "ruff check";
                  package = ruff;
                  # ERA001: catch commented-out code - here because we don't want it for normal dev
                  # ISC001: check for implicitly concatenated strings - disabled for format
                  args = [
                    "check"
                    "--fix"
                    "--extend-select=ERA001,ISC001"
                    "--unfixable=ERA001"
                  ];
                })
                (py {
                  name = "ruff format";
                  package = ruff;
                  args = [ "format" ];
                })
                (py {
                  package = mypy;
                  id = "dmypy";
                  args = [
                    "run"
                    "."
                  ];
                  pass_filenames = false;
                })
                (py {
                  package = vulture;
                  args = [ "." ];
                  pass_filenames = false;
                })
                # yaml
                {
                  package = yamlfix;
                  args = [
                    "--exclude=.pre-commit-config.yaml"
                    "."
                  ];
                  types = [ "yaml" ];
                }
                {
                  package = yamllint;
                  args = [ "." ];
                  types = [ "yaml" ];
                }
                # misc
                {
                  package = taplo;
                  args = [ "format" ];
                  types = [ "toml" ];
                }
                { package = typos; }
              ];
          in
          mkShellNoCC {
            inherit (pre-commit) packages shellHook;
            inputsFrom = [ (pkgs.callPackage ./dev.nix { inherit python; }) ];
          };

        formatter = pkgs.nixfmt-rfc-style;

        packages.default = pkgs.callPackage ./default.nix { inherit python; };

      }
    );
}
