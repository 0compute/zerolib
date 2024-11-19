{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-pre-commit = {
      url = "github:kingarrrt/nix-pre-commit";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      packageOverrides = import ./overlay.nix;
      pre-commit = import ./pre-commit.nix;
      project = inputs.pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let

        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        formatter = pkgs.nixfmt-rfc-style;

        overlay =
          python:
          python.override {
            inherit packageOverrides;
          };

        package =
          python:
          let
            attrs = project.renderers.buildPythonPackage { inherit python; };
          in
          with python.pkgs;
          buildPythonPackage (
            lib.recursiveUpdate attrs rec {
              optional-dependencies =
                let
                  replace =
                    extra: name:
                    (builtins.filter (pkg: pkg.pname != name) attrs.optional-dependencies.${extra})
                    ++ [ python.pkgs."${name}-local" ];
                in
                {
                  test = (replace "test" "typeguard") ++ [
                    pytestCheckHook
                  ];
                };
              checkInputs = optional-dependencies.test;
            }
          );

        shells =
          builtins.mapAttrs
            (
              _name: interpreter:
              let
                python = overlay interpreter;
                pkg = package python;
              in
              pkgs.mkShellNoCC {
                inherit (python) name;
                inherit
                  (pre-commit {
                    inherit
                      pkgs
                      system
                      inputs
                      python
                      formatter
                      ;
                  })
                  packages
                  shellHook
                  ;
                inputsFrom = [
                  (pkg.overridePythonAttrs {
                    nativeBuildInputs =
                      pkg.nativeBuildInputs
                      ++ pkg.optional-dependencies.dev
                      ++ (with pkgs; [
                        cachix
                      ]);
                    shellHook = ''
                      runHook preShellHook
                      hash=$(nix hash file pyproject.toml flake.lock *.nix \
                        | sha1sum \
                        | awk '{print $1}')
                      prefix="''${XDG_CACHE_HOME:-$HOME/.cache}/nixpkgs/pip-shell-hook/''${PWD//\//%}/$hash"
                      PATH="$prefix/bin:$PATH"
                      export NIX_PYTHONPATH="$prefix/${python.sitePackages}:''${NIX_PYTHONPATH-}"
                      [ -d "$prefix" ] || ${lib.getExe' python.pkgs.pip "pip"} install \
                        --no-deps --editable . --prefix "$prefix" --no-build-isolation >&2
                      runHook postShellHook
                    '';
                  })
                ];
              }

            )
            (
              lib.filterAttrs (
                name: python:
                python ? implementation
                && python.implementation == "cpython"
                && (lib.all (
                  spec:
                  with inputs.pyproject-nix.lib;
                  pep440.comparators.${spec.op} (pep508.mkEnviron python).python_full_version.value spec.version
                ) project.requires-python)
                && (builtins.substring 7 15 name) != "Minimal"
              ) pkgs.pythonInterpreters
            );

        python = overlay pkgs.python3;

      in
      {

        inherit formatter;

        devShells = shells // {
          default = shells.${python.pythonAttr};
        };

        packages.default = package python;

      }
    );

}
