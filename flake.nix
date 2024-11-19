{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pyproject = {
      url = "github:0compute/pyproject";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.pyproject.lib.mkPythonProject {
      projectRoot = ./.;
      packageOverrides = import ./overlay.nix;
      pre-commit = import ./pre-commit.nix;
      dev-pkgs =
        pkgs:
        (with pkgs; [
          cachix
          gnumake
        ]);
    };

}
