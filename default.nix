{ pkgs, python }:
let
  lib = import ./lib.nix { inherit (pkgs) lib; };
in
with (python.override {
  packageOverrides =
    _self: super:
    with super;
    let
      override =
        pname: version: hash:
        lib.override super pname version hash;
    in
    rec {

      atools = buildPythonPackage rec {
        pname = "atools";
        version = "0.14.2";
        src = fetchPypi {
          inherit pname;
          inherit version;
          sha256 = "ae2e518fb51355a03c1564b5ba80c7a7d28d1fc3e465fa391bde56e5582e8463";
        };
        patchPhase = "touch atools/py.typed";
        propagatedBuildInputs = [ frozendict ];
        meta = {
          description = "Python 3.6+ async/sync memoize and rate decorators";
          homepage = "https://github.com/cevans87/atools";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = [ "atools" ];
      };

      contextvars-extras = buildPythonPackage rec {
        pname = "contextvars_extras";
        version = "0.3.0";
        pyproject = true;
        src = fetchPypi {
          inherit pname;
          inherit version;
          sha256 = "4fd84e7bd8352c1d2cb7e5f2e260994cd8c3cbf35ca83785fb24476a8ad4fe0f";
        };
        patchPhase = "touch contextvars_extras/py.typed";
        nativeBuildInputs = [ poetry-core ];
        propagatedBuildInputs = [ sentinel-value ];
        meta = {
          description = "Contextvars made easy (WARNING: unstable alpha version. Things may break).";
          homepage = "https://github.com/vdmit11/contextvars-extras";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = [ "contextvars_extras" ];
      };

      deepmerge = override "deepmerge" "2.0" "sha256-XD2GCB++vQTdXeA2JqBge4CamPtsy6V3C2JGb+lA/yA=";

      sentinel-value = buildPythonPackage rec {
        pname = "sentinel-value";
        version = "1.0.0";
        pyproject = true;
        src = fetchPypi {
          inherit pname;
          inherit version;
          sha256 = "2ff8e9e303c8f6abb2ad8c6d2615ed5f11061eeda2e51edfd560dc0567de633a";
        };
        nativeBuildInputs = [ poetry-core ];
        meta = {
          description = "Sentinel Values - unique objects akin to None, True, False";
          homepage = "https://github.com/vdmit11/sentinel-value";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = [ "sentinel_value" ];
      };

      typeguard = override "typeguard" "4.4.1" "sha256-DSKonQC0U7R8SYdfQrZgG5YXV1QaLh4O9Re24kITwhs=";
    };
}).pkgs;

buildPythonPackage rec {

  pname = "zerolib";
  inherit ((builtins.fromTOML (builtins.readFile ./pyproject.toml)).project) version;
  pyproject = true;

  src = pkgs.nix-gitignore.gitignoreSource "/*.nix" (
    builtins.path {
      name = pname;
      path = ./.;
    }
  );

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    typeguard
  ];

  propagatedBuildInputs = [
    aiofiles
    anyio
    appdirs
    atools
    contextvars-extras
    deepmerge
    loguru
    msgpack
    msgspec
    pyyaml
    rustworkx
    wrapt
  ];

  pythonImportsCheck = [ "zerolib" ];

}
