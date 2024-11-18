{
  pkgs,
  python,
}:
let
  lib = import ./lib.nix { inherit (pkgs) lib; };
  pythonx = python.override {

    packageOverrides =
      _self: super:
      with super;
      let
        override =
          pname: version: hash:
          lib.override super pname version hash;
      in
      rec {

        fancycompleter = buildPythonPackage rec {
          pname = "fancycompleter";
          version = "0.9.1";
          src = fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "09e0feb8ae242abdfd7ef2ba55069a46f011814a80fe5476be48f51b00247272";
          };
          nativeBuildInputs = [ setupmeta ];
          propagatedBuildInputs = [ pyrepl ];
          meta = {
            description = "colorful TAB completion for Python prompt";
            homepage = "https://github.com/pdbpp/fancycompleter";
            license = pkgs.lib.licenses.bsdOriginal;
          };
          pythonImportsCheck = [ "fancycompleter" ];
        };

        pdbpp = buildPythonPackage rec {
          pname = "pdbpp";
          version = "0.10.3";
          src = fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "d9e43f4fda388eeb365f2887f4e7b66ac09dce9b6236b76f63616530e2f669f5";
          };
          nativeBuildInputs = [ setuptools-scm ];
          propagatedBuildInputs = [
            fancycompleter
            pygments
            wmctrl
          ];
          meta = {
            description = "pdb++, a drop-in replacement for pdb";
            homepage = "http://github.com/antocuni/pdb";
            license = pkgs.lib.licenses.bsdOriginal;
          };
          pythonImportsCheck = [ "pdb" ];
        };

        pyrepl = buildPythonPackage rec {
          pname = "pyrepl";
          version = "0.9.0";
          src = fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "292570f34b5502e871bbb966d639474f2b57fbfcd3373c2d6a2f3d56e681a775";
          };
          meta = {
            description = "A library for building flexible command line interfaces";
            homepage = "http://bitbucket.org/pypy/pyrepl/";
            license = "MIT X11 style";
          };
          pythonImportsCheck = [ "pyrepl" ];
        };

        pytest-cov = super.pytest-cov.overridePythonAttrs {
          propagatedBuildInputs = [
            (override "coverage" "7.6.7" "sha256-151IJuQUQcmhGP8EXkvMuf29yx0CQT5+putch7VDnSQ=")
            toml
          ];
        };

        types-aiofiles = buildPythonPackage rec {
          pname = "types-aiofiles";
          version = "23.1.0.2";
          src = fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "ea0a659f7cdd689a65a4e56170299d5d3c848b46984789b5302567f843a51462";
          };
          meta = {
            description = "Typing stubs for aiofiles";
            homepage = "https://github.com/python/typeshed";
            license = pkgs.lib.licenses.asl20;
          };
          pythonImportsCheck = [ "aiofiles-stubs" ];
        };

        wmctrl = buildPythonPackage rec {
          pname = "wmctrl";
          version = "0.4";
          src = fetchPypi {
            inherit pname;
            inherit version;
            sha256 = "66cbff72b0ca06a22ec3883ac3a4d7c41078bdae4fb7310f52951769b10e14e0";
          };
          dontUsePythonImportsCheck = true;
          meta = {
            description = "A tool to programmatically control windows inside X";
            homepage = "https://github.com/antocuni/wmctrl";
            license = pkgs.lib.licenses.mit;
          };
        };
      };
  };

  default = pkgs.callPackage ./default.nix { python = pythonx; };

in

with pythonx.pkgs;

default.overridePythonAttrs {

  pname = default.pname + "-dev";

  nativeBuildInputs =
    default.nativeBuildInputs
    ++ [
      flit
      mypy
      pdbpp
      pip # because we're using a custom shellHook
      ptpython
      pytest-cov
      pytest-random-order
      pytest-sugar
      types-aiofiles
      types-appdirs
      types-pyyaml
      vulture
    ]
    ++ (with pkgs; [
      cachix
    ]);

  # preShellHook = "rm -rf *.dist-info *.egg-info";

  # Install editable with install cache in XDG_CACHE_HOME.
  shellHook = ''
    runHook preShellHook

    # Install editable to $XDG_CACHE_HOME keyed on $PWD and hash of pyproject.toml
    # and/or setup.{cfg,py}
    files=()
    for file in pyproject.toml setup.py setup.cfg flake.* default.nix; do
    ! [ -e $file ] || files+=($file)
    done
    if (( ''${#files} )); then
    hash=$(nix hash file "''${files[@]}" | sha1sum | awk '{print $1}')
    prefix="''${XDG_CACHE_HOME:-$HOME/.cache}/nixpkgs/pip-shell-hook/''${PWD//\//%}/$hash"
    PATH="$prefix/bin:$PATH"
    # Process pth file installed in cache path. This allows one to
    # actually import the editable installation. Note site.addsitedir
    # appends, not prepends, new paths. Hence, it is not possible to override
    # an existing installation of the package.
    # https://github.com/pypa/setuptools/issues/2612
    export NIX_PYTHONPATH="$prefix/${python.sitePackages}:''${NIX_PYTHONPATH-}"
    [ -d "$prefix" ] || ${python.interpreter} -m \
        pip install --no-deps --editable . --prefix "$prefix" --no-build-isolation >&2
    fi

    runHook postShellHook
  '';

}
