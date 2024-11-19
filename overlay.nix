self: super:
with super;
let
  pkg-ref = pname: if builtins.hasAttr pname super then super.${pname} else self.${pname};
  override =
    pname: attrs:
    let
      pkg = pkg-ref pname;
    in
    (pkg.overridePythonAttrs attrs)
    // {
      pname = pkg.pname + "-override";
    };
  upgrade =
    pname: version: hash:
    let
      pkg = pkg-ref pname;
    in
    assert super.lib.assertMsg (
      builtins.compareVersions pkg.version version == -1
    ) "${pname} ${pkg.version} to ${version} is not an upgrade";
    override pname {
      inherit version;
      src = super.fetchPypi { inherit pname version hash; };
    };
  replace =
    name: packages:
    (builtins.filter (pkg: !(pkg ? pname && pkg.pname == name)) packages) ++ [ self."${name}-local" ];
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

  coverage-local = upgrade "coverage" "7.6.7" "sha256-151IJuQUQcmhGP8EXkvMuf29yx0CQT5+putch7VDnSQ=";

  deepmerge = upgrade "deepmerge" "2.0" "sha256-XD2GCB++vQTdXeA2JqBge4CamPtsy6V3C2JGb+lA/yA=";

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

  pytest-cov = override "pytest-cov" (pkg: {
    propagatedBuildInputs = replace "coverage" pkg.propagatedBuildInputs;
  });

  pytest-local = pytestCheckHook;

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

  # local override so other packages that depend on it are not rebuilt
  typeguard-local = upgrade "typeguard" "4.4.1" "sha256-DSKonQC0U7R8SYdfQrZgG5YXV1QaLh4O9Re24kITwhs=";

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

}
