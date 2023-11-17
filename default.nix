{pkgs}: let
  python = pkgs.python311;
in
  with rec {
    aiofiles =
      python.pkgs.buildPythonPackage rec
      {
        pname = "aiofiles";
        version = "23.1.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "edd247df9a19e0db16534d4baaf536d6609a43e1de5401d7a4c1c148753a1635";
          };
        nativeBuildInputs = [poetry-core];
        doCheck = false;
        meta = {
          description = "File support for asyncio.";
          homepage = "https://github.com/Tinche/aiofiles";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["aiofiles"];
      };

    aiohttp =
      python.pkgs.buildPythonPackage rec
      {
        pname = "aiohttp";
        version = "3.8.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "bf2e1a9162c1e441bf805a1fd166e249d574ca04e03b34f97e2928769e91ab5c";
          };
        nativeBuildInputs = [setuptools];
        propagatedBuildInputs = [aiosignal async-timeout attrs charset-normalizer yarl];
        patchPhase = "rm tests/test_proxy_functional.py";
        doCheck = false;
        meta = {
          description = "Async http client/server framework (asyncio)";
          homepage = "https://github.com/aio-libs/aiohttp";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["aiohttp"];
      };

    aiohttp-cors =
      python.pkgs.buildPythonPackage rec
      {
        pname = "aiohttp-cors";
        version = "0.7.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4d39c6d7100fd9764ed1caf8cebf0eb01bf5e3f24e2e073fda6234bc48b19f5d";
          };
        propagatedBuildInputs = [aiohttp];
        doCheck = false;
        meta = {
          description = "CORS support for aiohttp";
          homepage = "https://github.com/aio-libs/aiohttp-cors";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["aiohttp_cors"];
      };

    aiosignal =
      python.pkgs.buildPythonPackage rec
      {
        pname = "aiosignal";
        version = "1.3.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc";
          };
        nativeBuildInputs = [setuptools];
        propagatedBuildInputs = [frozenlist];
        doCheck = false;
        meta = {
          description = "aiosignal: a list of registered asynchronous callbacks";
          homepage = "https://github.com/aio-libs/aiosignal";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["aiosignal"];
      };

    anyio =
      python.pkgs.buildPythonPackage rec
      {
        pname = "anyio";
        version = "3.6.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [idna sniffio];
        doCheck = false;
        meta = {
          description = "High level compatibility layer for multiple asynchronous event loop implementations";
          homepage = "https://anyio.readthedocs.io/en/latest/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["anyio"];
      };

    appdirs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "appdirs";
        version = "1.4.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41";
          };
        doCheck = false;
        meta = {
          description = "A small Python module for determining appropriate platform-specific dirs, e.g. a \"user data dir\".";
          homepage = "http://github.com/ActiveState/appdirs";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["appdirs"];
      };

    async-timeout =
      python.pkgs.buildPythonPackage rec
      {
        pname = "async-timeout";
        version = "4.0.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Timeout context manager for asyncio programs";
          homepage = "https://github.com/aio-libs/async-timeout";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["async_timeout"];
      };

    atools =
      python.pkgs.buildPythonPackage rec
      {
        pname = "atools";
        version = "0.14.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "ae2e518fb51355a03c1564b5ba80c7a7d28d1fc3e465fa391bde56e5582e8463";
          };
        propagatedBuildInputs = [frozendict];
        doCheck = false;
        meta = {
          description = "Python 3.6+ async/sync memoize and rate decorators";
          homepage = "https://github.com/cevans87/atools";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["atools"];
      };

    attrs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "attrs";
        version = "23.1.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015";
          };
        nativeBuildInputs = [hatch-fancy-pypi-readme hatch-vcs];
        doCheck = false;
        meta = {
          description = "Classes Without Boilerplate";
          homepage = "https://github.com/python-attrs/attrs";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["attr" "attrs"];
      };

    beautifulsoup4 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "beautifulsoup4";
        version = "4.12.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da";
          };
        nativeBuildInputs = [hatchling];
        propagatedBuildInputs = [soupsieve];
        doCheck = false;
        meta = {
          description = "Screen-scraping library";
          homepage = "https://www.crummy.com/software/beautifulsoup/bs4/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["bs4"];
      };

    beniget =
      python.pkgs.buildPythonPackage rec
      {
        pname = "beniget";
        version = "0.4.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "75554b3b8ad0553ce2f607627dad3d95c60c441189875b98e097528f8e23ac0c";
          };
        propagatedBuildInputs = [gast];
        doCheck = false;
        meta = {
          description = "Extract semantic information about static Python code";
          homepage = "https://github.com/serge-sans-paille/beniget/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["beniget"];
      };

    black =
      python.pkgs.buildPythonPackage rec
      {
        pname = "black";
        version = "23.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1c7b8d606e728a41ea1ccbd7264677e494e87cf630e399262ced92d4a8dac940";
          };
        nativeBuildInputs = [hatch-fancy-pypi-readme hatch-vcs];
        propagatedBuildInputs = [
          aiohttp-cors
          click
          mypy-extensions
          packaging
          pathspec
          platformdirs
        ];
        doCheck = false;
        meta = {
          description = "The uncompromising code formatter.";
          homepage = "https://github.com/psf/black";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["black" "blackd" "blib2to3"];
      };

    bleach =
      python.pkgs.buildPythonPackage rec
      {
        pname = "bleach";
        version = "6.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1a1a85c1595e07d8db14c5f09f09e6433502c51c595970edc090551f0db99414";
          };
        propagatedBuildInputs = [six webencodings];
        doCheck = false;
        meta = {
          description = "An easy safelist-based HTML-sanitizing tool.";
          homepage = "https://github.com/mozilla/bleach";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["bleach"];
      };

    calver =
      python.pkgs.buildPythonPackage rec
      {
        pname = "calver";
        version = "2022.6.26";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e05493a3b17517ef1748fbe610da11f10485faa7c416b9d33fd4a52d74894f8b";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Setuptools extension for CalVer package versions";
          homepage = "https://github.com/di/calver";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["calver"];
      };

    cattrs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cattrs";
        version = "22.2.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f0eed5642399423cf656e7b66ce92cdc5b963ecafd041d1b24d136fdde7acf6d";
          };
        nativeBuildInputs = [poetry-core];
        propagatedBuildInputs = [attrs];
        doCheck = false;
        meta = {
          description = "Composable complex class support for attrs and dataclasses.";
          homepage = "https://github.com/python-attrs/cattrs";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["cattr" "cattrs"];
      };

    certifi =
      python.pkgs.buildPythonPackage rec
      {
        pname = "certifi";
        version = "2023.5.7";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7";
          };
        doCheck = false;
        meta = {
          description = "Python package for providing Mozilla's CA Bundle.";
          homepage = "https://github.com/certifi/python-certifi";
          license = pkgs.lib.licenses.mpl20;
        };
        pythonImportsCheck = ["certifi"];
      };

    cffi =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cffi";
        version = "1.15.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9";
          };
        buildInputs = [pkgs.libffi];
        propagatedBuildInputs = [pycparser];
        doCheck = false;
        meta = {
          description = "Foreign Function Interface for Python calling C code.";
          homepage = "http://cffi.readthedocs.org";
          license = pkgs.lib.licenses.mit;
        };
        inherit (python.pkgs.cffi) postPatch;
        pythonImportsCheck = ["cffi"];
        inherit (python.pkgs.cffi) NIX_CFLAGS_COMPILE;
      };

    cfgv =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cfgv";
        version = "3.3.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736";
          };
        doCheck = false;
        meta = {
          description = "Validate configuration and produce human readable error messages.";
          homepage = "https://github.com/asottile/cfgv";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["cfgv"];
      };

    charset-normalizer =
      python.pkgs.buildPythonPackage rec
      {
        pname = "charset-normalizer";
        version = "3.1.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5";
          };
        doCheck = false;
        meta = {
          description = "The Real First Universal Charset Detector. Open, modern and actively maintained alternative to Chardet.";
          homepage = "https://github.com/Ousret/charset_normalizer";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["charset_normalizer"];
      };

    click =
      python.pkgs.buildPythonPackage rec
      {
        pname = "click";
        version = "8.1.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e";
          };
        doCheck = false;
        meta = {
          description = "Composable command line interface toolkit";
          homepage = "https://palletsprojects.com/p/click/";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["click"];
      };

    coloredlogs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "coloredlogs";
        version = "15.0.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0";
          };
        propagatedNativeBuildInputs = [pkgs.utillinux];
        propagatedBuildInputs = [humanfriendly];
        doCheck = false;
        meta = {
          description = "Colored terminal output for Python's logging module";
          homepage = "https://coloredlogs.readthedocs.io";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["coloredlogs"];
      };

    contextvars-extras =
      python.pkgs.buildPythonPackage rec
      {
        pname = "contextvars_extras";
        version = "0.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4fd84e7bd8352c1d2cb7e5f2e260994cd8c3cbf35ca83785fb24476a8ad4fe0f";
          };
        nativeBuildInputs = [poetry-core];
        propagatedBuildInputs = [sentinel-value];
        doCheck = false;
        meta = {
          description = "Contextvars made easy (WARNING: unstable alpha version. Things may break).";
          homepage = "https://github.com/vdmit11/contextvars-extras";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["contextvars_extras"];
      };

    contourpy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "contourpy";
        version = "1.0.7";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d8165a088d31798b59e91117d1f5fc3df8168d8b48c4acc10fc0df0d0bdbcc5e";
          };
        nativeBuildInputs = [pybind11 setuptools];
        propagatedBuildInputs = [numpy];
        doCheck = false;
        meta = {
          description = "Python library for calculating contours of 2D quadrilateral grids";
          homepage = "https://contourpy.readthedocs.io";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["contourpy"];
      };

    coverage =
      python.pkgs.buildPythonPackage rec
      {
        pname = "coverage";
        version = "7.2.5";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f99ef080288f09ffc687423b8d60978cf3a465d3f404a18d1a05474bd8575a47";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Code coverage measurement for Python";
          homepage = "https://github.com/nedbat/coveragepy";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["coverage"];
      };

    cppy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cppy";
        version = "1.2.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "83b43bf17b1085ac15c5debdb42154f138b928234b21447358981f69d0d6fe1b";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          homepage = "https://github.com/nucleic/cppy";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["cppy"];
      };

    cryptography =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cryptography";
        version = "40.0.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99";
          };
        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.rustPlatform.cargoSetupHook
          pkgs.cargo
          pkgs.rustc
          setuptools-rust
        ];
        buildInputs = [pkgs.openssl];
        propagatedBuildInputs = [cffi];
        cargoDeps =
          pkgs.rustPlatform.importCargoLock
          {
            lockFile =
              pkgs.runCommand
              "${pname}-${version}-cargo-lock"
              {inherit src;}
              "tar -zxOf $src ${pname}-${version}/src/rust/Cargo.lock > $out";
          };
        cargoRoot = "src/rust";
        doCheck = false;
        meta = {
          description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
          homepage = "https://github.com/pyca/cryptography";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["cryptography"];
      };

    cycler =
      python.pkgs.buildPythonPackage rec
      {
        pname = "cycler";
        version = "0.11.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9c87405839a19696e837b3b818fed3f5f69f16f1eec1a1ad77e043dcea9c772f";
          };
        doCheck = false;
        meta = {
          description = "Composable style cycles";
          homepage = "https://github.com/matplotlib/cycler";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["cycler"];
      };

    cython =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Cython";
        version = "0.29.34";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1909688f5d7b521a60c396d20bba9e47a1b2d2784bfb085401e1e1e7d29a29a8";
          };
        buildInputs = [pgen];
        doCheck = false;
        meta = {
          description = "The Cython compiler for writing C extensions for the Python language.";
          homepage = "http://cython.org/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["cython" "Cython" "pyximport"];
      };

    deepmerge =
      python.pkgs.buildPythonPackage rec
      {
        pname = "deepmerge";
        version = "1.1.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4c27a0db5de285e1a7ceac7dbc1531deaa556b627dea4900c8244581ecdfea2d";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "a toolset to deeply merge python dictionaries.";
          homepage = "http://deepmerge.readthedocs.io/en/latest/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["deepmerge"];
      };

    defusedxml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "defusedxml";
        version = "0.7.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69";
          };
        doCheck = false;
        meta = {
          description = "XML bomb protection for Python stdlib modules";
          homepage = "https://github.com/tiran/defusedxml";
          license = pkgs.lib.licenses.psfl;
        };
        pythonImportsCheck = ["defusedxml"];
      };

    deprecated =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Deprecated";
        version = "1.2.13";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d";
          };
        propagatedBuildInputs = [wrapt];
        doCheck = false;
        meta = {
          description = "Python @deprecated decorator to deprecate old python classes, functions or methods.";
          homepage = "https://github.com/tantale/deprecated";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["deprecated"];
      };

    distlib =
      python.pkgs.buildPythonPackage rec
      {
        pname = "distlib";
        version = "0.3.6";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Distribution utilities";
          homepage = "https://github.com/pypa/distlib";
          license = pkgs.lib.licenses.psfl;
        };
        pythonImportsCheck = ["distlib"];
      };

    distro =
      python.pkgs.buildPythonPackage rec
      {
        pname = "distro";
        version = "1.8.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Distro - an OS platform information API";
          homepage = "https://github.com/python-distro/distro";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["distro"];
      };

    docstring-to-markdown =
      python.pkgs.buildPythonPackage rec
      {
        pname = "docstring-to-markdown";
        version = "0.12";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "40004224b412bd6f64c0f3b85bb357a41341afd66c4b4896709efa56827fb2bb";
          };
        doCheck = false;
        meta = {
          description = "On the fly conversion of Python docstrings to markdown";
          homepage = "https://github.com/python-lsp/docstring-to-markdown";
          license = pkgs.lib.licenses.lgpl21Plus;
        };
      };

    editables =
      python.pkgs.buildPythonPackage rec
      {
        pname = "editables";
        version = "0.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "167524e377358ed1f1374e61c268f0d7a4bf7dbd046c656f7b410cde16161b1a";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Editable installations";
          homepage = "https://github.com/pfmoore/editables";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["editables"];
      };

    execnet =
      python.pkgs.buildPythonPackage rec
      {
        pname = "execnet";
        version = "1.9.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8f694f3ba9cc92cab508b152dcfe322153975c29bda272e2fd7f3f00f36e47c5";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "execnet: rapid multi-Python deployment";
          homepage = "https://execnet.readthedocs.io/en/latest/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["execnet"];
      };

    fancycompleter =
      python.pkgs.buildPythonPackage rec
      {
        pname = "fancycompleter";
        version = "0.9.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "09e0feb8ae242abdfd7ef2ba55069a46f011814a80fe5476be48f51b00247272";
          };
        nativeBuildInputs = [setupmeta];
        propagatedBuildInputs = [pyrepl];
        doCheck = false;
        meta = {
          description = "colorful TAB completion for Python prompt";
          homepage = "https://github.com/pdbpp/fancycompleter";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["fancycompleter"];
      };

    fastjsonschema =
      python.pkgs.buildPythonPackage rec
      {
        pname = "fastjsonschema";
        version = "2.16.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4a30d6315a68c253cfa8f963b9697246315aa3db89f98b97235e345dedfb0b8e";
          };
        doCheck = false;
        meta = {
          description = "Fastest Python implementation of JSON schema";
          homepage = "https://github.com/horejsek/python-fastjsonschema";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["fastjsonschema"];
      };

    filelock =
      python.pkgs.buildPythonPackage rec
      {
        pname = "filelock";
        version = "3.12.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718";
          };
        nativeBuildInputs = [hatch-vcs];
        doCheck = false;
        meta = {
          description = "A platform independent file lock.";
          homepage = "https://github.com/tox-dev/py-filelock";
          license = pkgs.lib.licenses.unlicense;
        };
        pythonImportsCheck = ["filelock"];
      };

    flit-core =
      python.pkgs.buildPythonPackage rec
      {
        pname = "flit_core";
        version = "3.9.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba";
          };
        doCheck = false;
        meta = {
          description = "Distribution-building parts of Flit. See flit package for more information";
          homepage = "https://flit.pypa.io";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["flit_core"];
      };

    fonttools =
      python.pkgs.buildPythonPackage rec
      {
        pname = "fonttools";
        version = "4.39.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "dba8d7cdb8e2bac1b3da28c5ed5960de09e59a2fe7e63bb73f5a59e57b0430d2";
            extension = "zip";
          };
        doCheck = false;
        meta = {
          description = "Tools to manipulate font files";
          homepage = "http://github.com/fonttools/fonttools";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["fontTools"];
      };

    frilouz =
      python.pkgs.buildPythonPackage rec
      {
        pname = "frilouz";
        version = "0.0.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "ba7922f36500f6ea4a68e87f9cd24fe4a011a98673cb7ab4c7c3efcd33647a59";
          };
        doCheck = false;
        meta = {
          description = "Python AST parser adapter with partial error recovery";
          homepage = "https://github.com/serge-sans-paille/frilouz/";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["frilouz"];
      };

    frozendict =
      python.pkgs.buildPythonPackage rec
      {
        pname = "frozendict";
        version = "2.3.8";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "5526559eca8f1780a4ee5146896f59afc31435313560208dd394a3a5e537d3ff";
          };
        doCheck = false;
        meta = {
          description = "A simple immutable dictionary";
          homepage = "https://github.com/Marco-Sulla/python-frozendict";
          license = pkgs.lib.licenses.lgpl3Only;
        };
        pythonImportsCheck = ["frozendict"];
      };

    frozenlist =
      python.pkgs.buildPythonPackage rec
      {
        pname = "frozenlist";
        version = "1.3.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "A list-like structure which implements collections.abc.MutableSequence";
          homepage = "https://github.com/aio-libs/frozenlist";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["frozenlist"];
      };

    gast =
      python.pkgs.buildPythonPackage rec
      {
        pname = "gast";
        version = "0.5.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9c270fe5f4b130969b54174de7db4e764b09b4f7f67ccfc32480e29f78348d97";
          };
        doCheck = false;
        meta = {
          description = "Python AST that abstracts the underlying Python version";
          homepage = "https://github.com/serge-sans-paille/gast/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["gast"];
      };

    h11 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "h11";
        version = "0.14.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d";
          };
        doCheck = false;
        meta = {
          description = "A pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
          homepage = "https://github.com/python-hyper/h11";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["h11"];
      };

    hatch-fancy-pypi-readme =
      python.pkgs.buildPythonPackage rec
      {
        pname = "hatch_fancy_pypi_readme";
        version = "22.8.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "da91282ca09601c18aded8e378daf8b578c70214866f0971156ee9bb9ce6c26a";
          };
        propagatedBuildInputs = [hatchling];
        doCheck = false;
        meta = {
          description = "Fancy PyPI READMEs with Hatch";
          homepage = "https://github.com/hynek/hatch-fancy-pypi-readme";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["hatch_fancy_pypi_readme"];
      };

    hatch-nodejs-version =
      python.pkgs.buildPythonPackage rec
      {
        pname = "hatch_nodejs_version";
        version = "0.3.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0e55fd713d92c5c1ccfee778efecaa780fd8bcd276d4ca7aff9f6791f6f76d9c";
          };
        propagatedBuildInputs = [hatchling];
        doCheck = false;
        meta = {
          description = "Hatch plugin for versioning from a package.json file";
          homepage = "https://github.com/agoose77/hatch-nodejs-version";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["hatch_nodejs_version"];
      };

    hatch-requirements-txt =
      python.pkgs.buildPythonPackage rec
      {
        pname = "hatch_requirements_txt";
        version = "0.4.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "800509946e85d9e56d73242fab223ec36db50372e870a04e2dd1fd9bad98455d";
          };
        propagatedBuildInputs = [hatchling];
        doCheck = false;
        meta = {
          description = "Hatchling plugin to read project dependencies from requirements.txt";
          homepage = "https://github.com/repo-helper/hatch-requirements-txt";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["hatch_requirements_txt"];
      };

    hatch-vcs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "hatch_vcs";
        version = "0.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "cec5107cfce482c67f8bc96f18bbc320c9aa0d068180e14ad317bbee5a153fee";
          };
        propagatedBuildInputs = [hatchling setuptools-scm];
        doCheck = false;
        meta = {
          description = "Hatch plugin for versioning with your preferred VCS";
          homepage = "https://github.com/ofek/hatch-vcs";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["hatch_vcs"];
      };

    hatchling =
      python.pkgs.buildPythonPackage rec
      {
        pname = "hatchling";
        version = "1.17.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b1244db3f45b4ef5a00106a46612da107cdfaf85f1580b8e1c059fefc98b0930";
          };
        propagatedBuildInputs = [editables packaging pathspec pluggy trove-classifiers];
        doCheck = false;
        meta = {
          description = "Modern, extensible Python build backend";
          homepage = "https://hatch.pypa.io/latest/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["hatchling"];
      };

    httpcore =
      python.pkgs.buildPythonPackage rec
      {
        pname = "httpcore";
        version = "0.17.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "cc045a3241afbf60ce056202301b4d8b6af08845e3294055eb26b09913ef903c";
          };
        propagatedBuildInputs = [anyio certifi h11];
        doCheck = false;
        meta = {
          description = "A minimal low-level HTTP client.";
          homepage = "https://github.com/encode/httpcore";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["httpcore"];
      };

    httpx =
      python.pkgs.buildPythonPackage rec
      {
        pname = "httpx";
        version = "0.24.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "507d676fc3e26110d41df7d35ebd8b3b8585052450f4097401c9be59d928c63e";
          };
        nativeBuildInputs = [hatch-fancy-pypi-readme];
        propagatedBuildInputs = [httpcore];
        doCheck = false;
        meta = {
          description = "The next generation HTTP client.";
          homepage = "https://github.com/encode/httpx";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["httpx"];
      };

    humanfriendly =
      python.pkgs.buildPythonPackage rec
      {
        pname = "humanfriendly";
        version = "10.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc";
          };
        doCheck = false;
        meta = {
          description = "Human friendly output for text interfaces using Python";
          homepage = "https://humanfriendly.readthedocs.io";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["humanfriendly"];
      };

    identify =
      python.pkgs.buildPythonPackage rec
      {
        pname = "identify";
        version = "2.5.24";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0aac67d5b4812498056d28a9a512a483f5085cc28640b02b258a59dac34301d4";
          };
        doCheck = false;
        meta = {
          description = "File identification library for Python";
          homepage = "https://github.com/pre-commit/identify";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["identify"];
      };

    idna =
      python.pkgs.buildPythonPackage rec
      {
        pname = "idna";
        version = "3.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4";
          };
        nativeBuildInputs = [flit-core];
        doCheck = false;
        meta = {
          description = "Internationalized Domain Names in Applications (IDNA)";
          homepage = "https://github.com/kjd/idna";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["idna"];
      };

    iniconfig =
      python.pkgs.buildPythonPackage rec
      {
        pname = "iniconfig";
        version = "2.0.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3";
          };
        nativeBuildInputs = [hatch-vcs];
        doCheck = false;
        meta = {
          description = "brain-dead simple config-ini parsing";
          homepage = "https://github.com/pytest-dev/iniconfig";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["iniconfig"];
      };

    isort =
      python.pkgs.buildPythonPackage rec
      {
        pname = "isort";
        version = "5.12.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504";
          };
        nativeBuildInputs = [poetry-core];
        doCheck = false;
        meta = {
          description = "A Python utility / library to sort Python imports.";
          homepage = "https://pycqa.github.io/isort/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["isort"];
      };

    jedi =
      python.pkgs.buildPythonPackage rec
      {
        pname = "jedi";
        version = "0.18.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612";
          };
        propagatedBuildInputs = [parso];
        patchPhase = "sed -i 's/pytest<7.0.0/pytest/' setup.py";
        doCheck = false;
        meta = {
          description = "An autocompletion tool for Python that can be used for text editors.";
          homepage = "https://github.com/davidhalter/jedi";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["jedi"];
      };

    jinja2 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Jinja2";
        version = "3.1.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852";
          };
        propagatedBuildInputs = [markupsafe];
        doCheck = false;
        meta = {
          description = "A very fast and expressive template engine.";
          homepage = "https://palletsprojects.com/p/jinja/";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["jinja2"];
      };

    jsonschema =
      python.pkgs.buildPythonPackage rec
      {
        pname = "jsonschema";
        version = "4.17.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d";
          };
        nativeBuildInputs = [hatch-fancy-pypi-readme hatch-vcs];
        propagatedBuildInputs = [attrs pyrsistent];
        doCheck = false;
        meta = {
          description = "An implementation of JSON Schema validation for Python";
          homepage = "https://github.com/python-jsonschema/jsonschema";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["jsonschema"];
      };

    jupyter-client =
      python.pkgs.buildPythonPackage rec
      {
        pname = "jupyter_client";
        version = "8.2.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9fe233834edd0e6c0aa5f05ca2ab4bdea1842bfd2d8a932878212fc5301ddaf0";
          };
        nativeBuildInputs = [hatchling];
        propagatedBuildInputs = [jupyter-core python-dateutil pyzmq tornado];
        doCheck = false;
        meta = {
          description = "Jupyter protocol implementation and client libraries";
          homepage = "https://jupyter.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["jupyter_client"];
      };

    jupyter-core =
      python.pkgs.buildPythonPackage rec
      {
        pname = "jupyter_core";
        version = "5.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6db75be0c83edbf1b7c9f91ec266a9a24ef945da630f3120e1a0046dc13713fc";
          };
        nativeBuildInputs = [hatchling];
        propagatedBuildInputs = [platformdirs traitlets];
        doCheck = false;
        meta = {
          description = "Jupyter core package. A base package on which Jupyter projects rely.";
          homepage = "https://jupyter.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["jupyter_core"];
      };

    jupyterlab-pygments =
      python.pkgs.buildPythonPackage rec
      {
        pname = "jupyterlab_pygments";
        version = "0.2.2";
        format = "wheel";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            inherit format;
            sha256 = "2405800db07c9f770863bcf8049a529c3dd4d3e28536638bd7c1c01d2748309f";
          };
        doCheck = false;
        dontUsePythonImportsCheck = true;
        meta = {
          description = "Pygments theme using JupyterLab CSS variables";
          homepage = "https://github.com/jupyterlab/jupyterlab_pygments";
          license = pkgs.lib.licenses.bsdOriginal;
        };
      };

    kiwisolver =
      python.pkgs.buildPythonPackage rec
      {
        pname = "kiwisolver";
        version = "1.4.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d41997519fcba4a1e46eb4a2fe31bc12f0ff957b2b81bac28db24744f333e955";
          };
        nativeBuildInputs = [cppy setuptools-scm];
        doCheck = false;
        meta = {
          description = "A fast implementation of the Cassowary constraint solver";
          homepage = "https://github.com/nucleic/kiwi";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["kiwisolver"];
      };

    loguru =
      python.pkgs.buildPythonPackage rec
      {
        pname = "loguru";
        version = "0.7.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-5nGlNSJRXzT9QGNA7paMueyvvEs2xnnaA8GP2NC9Uaw";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        pythonImportsCheck = ["loguru"];
      };

    lsprotocol =
      python.pkgs.buildPythonPackage rec
      {
        pname = "lsprotocol";
        version = "2023.0.0a1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "32edfd4856abba1349bf5a070567445b3d7286951afba3644b472629796f82d0";
          };
        nativeBuildInputs = [flit-core];
        propagatedBuildInputs = [cattrs];
        doCheck = false;
        meta = {
          description = "Python implementation of the Language Server Protocol.";
          homepage = "https://github.com/microsoft/lsprotocol";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["lsprotocol"];
      };

    maison =
      python.pkgs.buildPythonPackage rec
      {
        pname = "maison";
        version = "1.4.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9843758d7772e0fc3ca93cf3abfdd39656f41bc75f026fd8bfb5a0ac17f27a7e";
          };
        nativeBuildInputs = [poetry-core];
        propagatedBuildInputs = [click pydantic toml];
        doCheck = false;
        meta = {
          description = "Maison";
          homepage = "https://github.com/dbatten5/maison";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["maison"];
      };

    manhole =
      python.pkgs.buildPythonPackage rec
      {
        pname = "manhole";
        version = "1.8.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "bada20a25b547b395d472e2e08928f0437df26bbdbda4797c55863198e29a21f";
          };
        doCheck = false;
        meta = {
          description = "Manhole is in-process service that will accept unix domain socket connections and present the";
          homepage = "https://github.com/ionelmc/python-manhole";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["manhole"];
      };

    markupsafe =
      python.pkgs.buildPythonPackage rec
      {
        pname = "MarkupSafe";
        version = "2.1.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d";
          };
        doCheck = false;
        meta = {
          description = "Safely add untrusted strings to HTML/XML markup.";
          homepage = "https://palletsprojects.com/p/markupsafe/";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["markupsafe"];
      };

    matplotlib =
      python.pkgs.buildPythonPackage rec
      {
        pname = "matplotlib";
        version = "3.7.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7b73305f25eab4541bd7ee0b96d87e53ae9c9f1823be5659b806cd85786fe882";
          };
        nativeBuildInputs = [certifi oldest-supported-numpy pybind11 setuptools-scm];
        propagatedBuildInputs = [
          contourpy
          cycler
          fonttools
          kiwisolver
          packaging
          pillow
          pkgs.freetype
          pkgs.qhull
          pyparsing
          python-dateutil
        ];
        patchPhase = "sed -i 's/setuptools_scm>=4,<7/setuptools-scm/' setup.py";
        doCheck = false;
        meta = {
          description = "Python plotting package";
          homepage = "https://matplotlib.org";
          license = pkgs.lib.licenses.psfl;
        };
        inherit (python.pkgs.matplotlib) postPatch;
        pythonImportsCheck = ["matplotlib" "mpl_toolkits"];
        inherit (python.pkgs.matplotlib) MPLSETUPCFG;
      };

    maturin =
      python.pkgs.buildPythonPackage rec
      {
        pname = "maturin";
        version = "0.15.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "247bec13d82021972e5cb4eb38e7a7aea0e7a034beab60f0e0464ffe7423f24b";
          };
        nativeBuildInputs = [
          pkgs.rustPlatform.cargoSetupHook
          pkgs.cargo
          pkgs.rustc
          setuptools-rust
        ];
        cargoDeps =
          pkgs.rustPlatform.importCargoLock
          {
            lockFile =
              pkgs.runCommand
              "${pname}-${version}-cargo-lock"
              {inherit src;}
              "tar -zxOf $src ${pname}-${version}/Cargo.lock > $out";
          };
        doCheck = false;
        meta = {
          description = "Build and publish crates with pyo3, rust-cpython and cffi bindings as well as rust binaries as python packages";
          homepage = "https://github.com/pyo3/maturin";
          license = "MIT OR Apache-2.0";
        };
        pythonImportsCheck = ["maturin"];
      };

    memestra =
      python.pkgs.buildPythonPackage rec
      {
        pname = "memestra";
        version = "0.2.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "eac8707fd0680df64ccb48ad3fc7ac34fe28bfa7f0e8b2693b763965a8700d9c";
          };
        propagatedBuildInputs = [beniget frilouz nbconvert pyyaml];
        doCheck = false;
        meta = {
          description = "Memestra checks code for places where deprecated functions are called";
          homepage = "https://github.com/QuantStack/memestra";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["memestra"];
      };

    mistune =
      python.pkgs.buildPythonPackage rec
      {
        pname = "mistune";
        version = "2.0.5";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0246113cb2492db875c6be56974a7c893333bf26cd92891c85f63151cee09d34";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "A sane Markdown parser with useful plugins and renderers";
          homepage = "https://github.com/lepture/mistune";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["mistune"];
      };

    msgpack =
      python.pkgs.buildPythonPackage rec
      {
        pname = "msgpack";
        version = "1.0.5";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c";
          };
        nativeBuildInputs = [cython setuptools];
        patchPhase = "sed -i 's/~=/>=/' pyproject.toml";
        doCheck = false;
        meta = {
          description = "MessagePack serializer";
          homepage = "https://msgpack.org/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["msgpack"];
      };

    msgspec =
      python.pkgs.buildPythonPackage rec
      {
        pname = "msgspec";
        version = "0.15.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d760ff747165d84965791bfcd14588f61f111708036d80f1980387e3760035e7";
          };
        doCheck = false;
        meta = {
          description = "A fast serialization and validation library, with builtin support for JSON, MessagePack, YAML, and TOML.";
          homepage = "https://jcristharif.com/msgspec/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["msgspec"];
      };

    multidict =
      python.pkgs.buildPythonPackage rec
      {
        pname = "multidict";
        version = "6.0.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49";
          };
        doCheck = false;
        meta = {
          description = "multidict implementation";
          homepage = "https://github.com/aio-libs/multidict";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["multidict"];
      };

    mypy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "mypy";
        version = "1.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e1f4d16e296f5135624b34e8fb741eb0eadedca90862405b1f1fde2040b9bd11";
          };
        nativeBuildInputs = [setuptools types-psutil types-setuptools types-typed-ast];
        propagatedBuildInputs = [mypy-extensions psutil typing-extensions];
        doCheck = false;
        meta = {
          description = "Optional static typing for Python";
          homepage = "https://www.mypy-lang.org/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["mypy" "mypyc"];
      };

    mypy-extensions =
      python.pkgs.buildPythonPackage rec
      {
        pname = "mypy_extensions";
        version = "1.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782";
          };
        doCheck = false;
        meta = {
          description = "Type system extensions for programs checked with the mypy type checker.";
          homepage = "https://github.com/python/mypy_extensions";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["mypy_extensions"];
      };

    nbclient =
      python.pkgs.buildPythonPackage rec
      {
        pname = "nbclient";
        version = "0.7.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d447f0e5a4cfe79d462459aec1b3dc5c2e9152597262be8ee27f7d4c02566a0d";
          };
        nativeBuildInputs = [hatchling];
        propagatedBuildInputs = [jupyter-client nbformat];
        doCheck = false;
        meta = {
          description = "A client library for executing notebooks. Formerly nbconvert's ExecutePreprocessor.";
          homepage = "https://jupyter.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["nbclient"];
      };

    nbconvert =
      python.pkgs.buildPythonPackage rec
      {
        pname = "nbconvert";
        version = "7.4.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "51b6c77b507b177b73f6729dba15676e42c4e92bcb00edc8cc982ee72e7d89d7";
          };
        nativeBuildInputs = [hatchling];
        propagatedBuildInputs = [
          beautifulsoup4
          bleach
          defusedxml
          jinja2
          jupyterlab-pygments
          mistune
          nbclient
          packaging
          pandocfilters
          pygments
          tinycss2
        ];
        doCheck = false;
        meta = {
          description = "Converting Jupyter Notebooks";
          homepage = "https://jupyter.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["nbconvert"];
      };

    nbformat =
      python.pkgs.buildPythonPackage rec
      {
        pname = "nbformat";
        version = "5.8.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "46dac64c781f1c34dfd8acba16547024110348f9fc7eab0f31981c2a3dc48d1f";
          };
        nativeBuildInputs = [hatch-nodejs-version];
        propagatedBuildInputs = [fastjsonschema jsonschema jupyter-core];
        doCheck = false;
        meta = {
          description = "The Jupyter Notebook format";
          homepage = "https://jupyter.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["nbformat"];
      };

    nodeenv =
      python.pkgs.buildPythonPackage rec
      {
        pname = "nodeenv";
        version = "1.8.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2";
          };
        propagatedBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Node.js virtual environment builder";
          homepage = "https://github.com/ekalinin/nodeenv";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["nodeenv"];
      };

    numpy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "numpy";
        version = "1.23.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b78d00e48261fbbd04aa0d7427cf78d18401ee0abd89c7559bbf422e5b1c7d01";
          };
        nativeBuildInputs = [cython pkgs.gfortran];
        buildInputs = [pkgs.blas pkgs.lapack pkgs.zlib];
        patchPhase = ''
          sed -Ei -e 's/setuptools==/setuptools>=/' -e 's/wheel==/wheel>=/' pyproject.toml
          rm numpy/array_api/tests/test_set_functions.py
        '';
        doCheck = false;
        inherit (python.pkgs.numpy) enableParallelBuilding;
        meta = {
          description = "NumPy is the fundamental package for array computing with Python.";
          homepage = "https://www.numpy.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        inherit (python.pkgs.numpy) patches;
        inherit (python.pkgs.numpy) preBuild;
        inherit (python.pkgs.numpy) preConfigure;
        pythonImportsCheck = ["numpy"];
      };

    oldest-supported-numpy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "oldest-supported-numpy";
        version = "2022.11.19";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0c9a490192eeec4a2e08bb945e00e82aa1230aad4a9616619eac683fa80a98fe";
          };
        propagatedBuildInputs = [numpy];
        doCheck = false;
        meta = {
          description = "Meta-package that provides the oldest NumPy that supports a given Python version and platform. If wheels for the platform became available on PyPI only for a more recent NumPy version, then that NumPy version is specified.";
          homepage = "https://github.com/scipy/oldest-supported-numpy";
          license = pkgs.lib.licenses.bsdOriginal;
        };
      };

    orjson =
      python.pkgs.buildPythonPackage rec
      {
        pname = "orjson";
        version = "3.8.12";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9f0f042cf002a474a6aea006dd9f8d7a5497e35e5fb190ec78eb4d232ec19955";
          };
        nativeBuildInputs = [
          maturin
          pkgs.rustPlatform.cargoSetupHook
          pkgs.cargo
          pkgs.rustc
        ];
        cargoDeps =
          pkgs.rustPlatform.importCargoLock
          {
            lockFile =
              pkgs.runCommand
              "${pname}-${version}-cargo-lock"
              {inherit src;}
              "tar -zxOf $src ${pname}-${version}/Cargo.lock > $out";
          };
        doCheck = false;
        meta = {
          description = "Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy";
          homepage = "https://github.com/ijl/orjson";
          license = pkgs.lib.licenses.asl20;
        };
      };

    packaging =
      python.pkgs.buildPythonPackage rec
      {
        pname = "packaging";
        version = "23.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f";
          };
        nativeBuildInputs = [flit-core];
        doCheck = false;
        meta = {
          description = "Core utilities for Python packages";
          homepage = "https://github.com/pypa/packaging";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["packaging"];
      };

    pandocfilters =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pandocfilters";
        version = "1.5.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38";
          };
        doCheck = false;
        meta = {
          description = "Utilities for writing pandoc filters in python";
          homepage = "http://github.com/jgm/pandocfilters";
          license = pkgs.lib.licenses.bsd3;
        };
        pythonImportsCheck = ["pandocfilters"];
      };

    parso =
      python.pkgs.buildPythonPackage rec
      {
        pname = "parso";
        version = "0.8.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0";
          };
        patchPhase = "sed -i 's/<6.0.0//' setup.py";
        doCheck = false;
        meta = {
          description = "A Python Parser";
          homepage = "https://github.com/davidhalter/parso";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["parso"];
      };

    pathspec =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pathspec";
        version = "0.11.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687";
          };
        nativeBuildInputs = [flit-core setuptools];
        doCheck = false;
        meta = {
          description = "Utility library for gitignore style pattern matching of file paths.";
          homepage = "https://github.com/cpburnz/python-pathspec";
          license = pkgs.lib.licenses.mpl20;
        };
        pythonImportsCheck = ["pathspec"];
      };

    patiencediff =
      python.pkgs.buildPythonPackage rec
      {
        pname = "patiencediff";
        version = "0.2.14";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a604d5727f996f0fd9de4534b143d3e803ec4f1b18e40cd78e91ab48a289a95f";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Python implementation of the patiencediff algorithm";
          homepage = "https://www.breezy-vcs.org/";
          license = pkgs.lib.licenses.gpl2Plus;
        };
        pythonImportsCheck = ["patiencediff"];
      };

    pbr =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pbr";
        version = "5.11.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3";
          };
        doCheck = false;
        meta = {
          description = "Python Build Reasonableness";
          homepage = "https://docs.openstack.org/pbr/latest/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["pbr"];
      };

    pdbpp =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pdbpp";
        version = "0.10.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d9e43f4fda388eeb365f2887f4e7b66ac09dce9b6236b76f63616530e2f669f5";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [fancycompleter pygments wmctrl];
        doCheck = false;
        meta = {
          description = "pdb++, a drop-in replacement for pdb";
          homepage = "http://github.com/antocuni/pdb";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pdb"];
      };

    pdm-pep517 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pdm-pep517";
        version = "1.1.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7f49121e70b42dca296fac962210dd2da07a39575fc5673137ad661633b2cf3f";
          };
        checkInputs = [pkgs.gitMinimal];
        doCheck = false;
        meta = {
          description = "A PEP 517 backend for PDM that supports PEP 621 metadata";
          homepage = "https://pdm.fming.dev";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pdm.pep517"];
      };

    pgen =
      python.pkgs.buildPythonPackage rec
      {
        pname = "PGen";
        version = "0.2.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f71b6a0f6c51c518e6ce2295f19b82f9687bfceb6f9f9be4376203ee4afdf90c";
            extension = "zip";
          };
        doCheck = false;
        meta = {
          description = "Useful tool to generate data & tests";
          homepage = "http://pypi.python.org/pypi/PGen/";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["pgen"];
      };

    pillow =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Pillow";
        version = "9.4.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a1c2d7780448eb93fbcc3789bf3916aa5720d942e37945f4056680317f1cd23e";
          };
        buildInputs = [
          pkgs.freetype
          pkgs.lcms2
          pkgs.libimagequant
          pkgs.libjpeg
          pkgs.libtiff
          pkgs.libwebp
          pkgs.openjpeg
          pkgs.tcl
          pkgs.zlib
        ];
        doCheck = false;
        meta = {
          description = "Python Imaging Library (Fork)";
          homepage = "https://python-pillow.org";
          license = pkgs.lib.licenses.hpnd;
        };
        inherit (python.pkgs.pillow) postPatch;
        preBuild = "export MAX_CONCURRENCY=$NIX_BUILD_CORES";
        inherit (python.pkgs.pillow) preConfigure;
        pythonImportsCheck = ["PIL"];
      };

    pip =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pip";
        version = "23.1.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0e7c86f486935893c708287b30bd050a36ac827ec7fe5e43fe7cb198dd835fba";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "The PyPA recommended tool for installing Python packages.";
          homepage = "https://pip.pypa.io/";
          license = pkgs.lib.licenses.mit;
        };
        pipInstallFlags = ["--ignore-installed"];
        pythonImportsCheck = ["pip"];
      };

    platformdirs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "platformdirs";
        version = "3.5.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "412dae91f52a6f84830f39a8078cecd0e866cb72294a5c66808e74d5e88d251f";
          };
        nativeBuildInputs = [hatch-vcs];
        doCheck = false;
        meta = {
          description = "A small Python package for determining appropriate platform-specific dirs, e.g. a \"user data dir\".";
          homepage = "https://github.com/platformdirs/platformdirs";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["platformdirs"];
      };

    pluggy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pluggy";
        version = "1.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "plugin and hook calling mechanisms for python";
          homepage = "https://github.com/pytest-dev/pluggy";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pluggy"];
      };

    poetry-core =
      python.pkgs.buildPythonPackage rec
      {
        pname = "poetry_core";
        version = "1.6.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a9c7296a12d6c8e4f8aa50a66ef3c967b2b50fba634da144d358e676fad9989f";
          };
        propagatedNativeBuildInputs = [pkgs.gitMinimal];
        doCheck = false;
        meta = {
          description = "Poetry PEP 517 Build Backend";
          homepage = "https://github.com/python-poetry/poetry-core";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["poetry.core"];
      };

    pre-commit =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pre_commit";
        version = "3.3.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "733f78c9a056cdd169baa6cd4272d51ecfda95346ef8a89bf93712706021b907";
          };
        propagatedBuildInputs = [cfgv identify nodeenv pyyaml virtualenv];
        doCheck = false;
        meta = {
          description = "A framework for managing and maintaining multi-language pre-commit hooks.";
          homepage = "https://github.com/pre-commit/pre-commit";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pre_commit"];
      };

    prompt-toolkit =
      python.pkgs.buildPythonPackage rec
      {
        pname = "prompt_toolkit";
        version = "3.0.38";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b";
          };
        propagatedBuildInputs = [wcwidth];
        doCheck = false;
        meta = {
          description = "Library for building powerful interactive command lines in Python";
          homepage = "https://github.com/prompt-toolkit/python-prompt-toolkit";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["prompt_toolkit"];
      };

    psutil =
      python.pkgs.buildPythonPackage rec
      {
        pname = "psutil";
        version = "5.9.5";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Cross-platform lib for process and system monitoring in Python.";
          homepage = "https://github.com/giampaolo/psutil";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["psutil"];
      };

    ptpython =
      python.pkgs.buildPythonPackage rec
      {
        pname = "ptpython";
        version = "3.0.23";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9fc9bec2cc51bc4000c1224d8c56241ce8a406b3d49ec8dc266f78cd3cd04ba4";
          };
        propagatedBuildInputs = [appdirs jedi prompt-toolkit pygments];
        doCheck = false;
        meta = {
          description = "Python REPL build on top of prompt_toolkit";
          homepage = "https://github.com/prompt-toolkit/ptpython";
          license = "Copyright (c) 2015, Jonathan Slenders";
        };
        pythonImportsCheck = ["ptpython"];
      };

    py-spy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "py_spy";
        version = "0.3.14";
        format = "wheel";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            inherit format;
            sha256 = "f59b0b52e56ba9566305236375e6fc68888261d0d36b5addbe3cf85affbefc0e";
            platform = "manylinux_2_5_x86_64.manylinux1_x86_64";
          };
        nativeBuildInputs = [pkgs.autoPatchelfHook];
        doCheck = false;
        meta = {
          description = "Sampling profiler for Python programs";
          homepage = "https://github.com/benfred/py-spy";
          license = pkgs.lib.licenses.mit;
        };
      };

    pybind11 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pybind11";
        version = "2.10.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0bb621d3c45a049aa5923debb87c5c0e2668227905c55ebe8af722608d8ed927";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Seamless operability between C++11 and Python";
          homepage = "https://github.com/pybind/pybind11";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pybind11"];
      };

    pycparser =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pycparser";
        version = "2.21";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206";
          };
        doCheck = false;
        meta = {
          description = "C parser in Python";
          homepage = "https://github.com/eliben/pycparser";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pycparser"];
      };

    pydantic =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pydantic";
        version = "1.10.7";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "cfc83c0678b6ba51b0532bea66860617c4cd4251ecf76e9846fa5a9f3454e97e";
          };
        propagatedBuildInputs = [typing-extensions];
        doCheck = false;
        meta = {
          description = "Data validation and settings management using python type hints";
          homepage = "https://github.com/pydantic/pydantic";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pydantic"];
      };

    pygls =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pygls";
        version = "1.0.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f3ee98ddbb4690eb5c755bc32ba7e129607f14cbd313575f33d0cea443b78cb2";
          };
        nativeBuildInputs = [setuptools-scm toml];
        propagatedBuildInputs = [lsprotocol typeguard];
        doCheck = false;
        meta = {
          description = "a pythonic generic language server (pronounced like \"pie glass\").";
          homepage = "https://github.com/openlawlibrary/pygls/tree/master/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["pygls"];
      };

    pygments =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Pygments";
        version = "2.15.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8ace4d3c1dd481894b2005f560ead0f9f19ee64fe983366be1a21e171d12775c";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Pygments is a syntax highlighting package written in Python.";
          homepage = "https://pygments.org";
          license = pkgs.lib.licenses.bsd2;
        };
        pythonImportsCheck = ["pygments"];
      };

    pygments-solarized =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pygments-solarized";
        version = "0.0.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6b5cf1c6db86fe3cc57ebb4a8e35c05fc928d36441959d0bffa44c4f65081816";
          };
        propagatedBuildInputs = [pygments];
        doCheck = false;
        meta = {
          description = "Pygments version of the solarized theme based on john2x/solarized-pygment.";
          homepage = "https://github.com/meganlkm/pygments-solarized";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pygments_solarized"];
      };

    pyinstrument =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyinstrument";
        version = "4.4.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "be34a2e8118c14a616a64538e02430d9099d5d67d8a370f2888e4ac71e52bbb7";
          };
        doCheck = false;
        meta = {
          description = "Call stack profiler for Python. Shows you why your code is slow!";
          homepage = "https://github.com/joerick/pyinstrument";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pyinstrument"];
      };

    pyls-isort =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyls-isort";
        version = "0.2.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2192bd2203db00459f85eb329521feba58af63075d2dd10a051a4eccd000bba0";
          };
        propagatedBuildInputs = [isort python-lsp-server];
        doCheck = false;
        meta = {
          description = "Isort plugin for python-lsp-server";
          homepage = "https://github.com/paradoxxxzero/pyls-isort";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pyls_isort"];
      };

    pyls-memestra =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyls-memestra";
        version = "0.0.16";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "ccc543776b81e339f0dfccf7c9bd0db7ba901f97461d36d004864efeaa35fedf";
          };
        propagatedBuildInputs = [deprecated memestra python-lsp-server];
        doCheck = false;
        meta = {
          description = "Memestra plugin for the Python Language Server";
          homepage = "https://github.com/QuantStack/pyls-memestra";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pyls_memestra"];
      };

    pylsp-mypy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pylsp-mypy";
        version = "0.6.6";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "aa5d547b25ca431b5b17689c495c55aa374b19b35c59746987e417044fb722ce";
          };
        propagatedBuildInputs = [mypy python-lsp-server];
        doCheck = false;
        meta = {
          description = "Mypy linter for the Python LSP Server";
          homepage = "https://github.com/python-lsp/pylsp-mypy";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pylsp_mypy"];
      };

    pyparsing =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyparsing";
        version = "3.0.9";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb";
          };
        nativeBuildInputs = [flit-core];
        doCheck = false;
        meta = {
          description = "pyparsing module - Classes and methods to define and execute parsing grammars";
          homepage = "https://github.com/pyparsing/pyparsing/";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["pyparsing"];
      };

    pyproject-metadata =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyproject-metadata";
        version = "0.7.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0a94f18b108b9b21f3a26a3d541f056c34edcb17dc872a144a15618fed7aef67";
          };
        nativeBuildInputs = [setuptools];
        propagatedBuildInputs = [packaging];
        doCheck = false;
        meta = {
          description = "PEP 621 metadata parsing";
          homepage = "https://github.com/ffy00/python-pyproject-metadata";
          license = pkgs.lib.licenses.mit;
        };
        patches = [
          (
            pkgs.fetchpatch
            {
              sha256 = "138afwasnxy4xhsiknh2f73j4cdqf6cw4qz3a87yvwb2yx6pqhgj";
              url = "https://github.com/kingarrrt/python-pyproject-metadata/commit/a4f4ae769d64ee4c41de4afdfaf9c060c6728c17.patch";
            }
          )
        ];
        pythonImportsCheck = ["pyproject_metadata"];
      };

    pyrepl =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyrepl";
        version = "0.9.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "292570f34b5502e871bbb966d639474f2b57fbfcd3373c2d6a2f3d56e681a775";
          };
        doCheck = false;
        meta = {
          description = "A library for building flexible command line interfaces";
          homepage = "http://bitbucket.org/pypy/pyrepl/";
          license = "MIT X11 style";
        };
        pythonImportsCheck = ["pyrepl"];
      };

    pyrsistent =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyrsistent";
        version = "0.19.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440";
          };
        nativeBuildInputs = [setuptools];
        patchPhase = "sed -i 's/<7//g' setup.py";
        doCheck = false;
        meta = {
          description = "Persistent/Functional/Immutable data structures";
          homepage = "https://github.com/tobgu/pyrsistent/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pyrsistent"];
      };

    pytest =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest";
        version = "7.3.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "434afafd78b1d78ed0addf160ad2b77a30d35d4bdf8af234fe621919d9ed15e3";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [iniconfig packaging pluggy];
        doCheck = false;
        meta = {
          description = "pytest: simple powerful testing with Python";
          homepage = "https://docs.pytest.org/en/latest/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["py" "pytest"];
      };

    pytest-asyncio =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest-asyncio";
        version = "0.21.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2b38a496aef56f56b0e87557ec313e11e1ab9276fc3863f6a7be0f1d0e415e1b";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [pytest];
        patchPhase = "sed -i 's/==/>=/' setup.cfg";
        doCheck = false;
        meta = {
          description = "Pytest support for asyncio";
          homepage = "https://github.com/pytest-dev/pytest-asyncio";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["pytest_asyncio"];
      };

    pytest-cov =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest-cov";
        version = "4.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "996b79efde6433cdbd0088872dbc5fb3ed7fe1578b68cdbba634f14bb8dd0470";
          };
        propagatedBuildInputs = [coverage pytest];
        doCheck = false;
        meta = {
          description = "Pytest plugin for measuring coverage.";
          homepage = "https://github.com/pytest-dev/pytest-cov";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pytest_cov"];
      };

    pytest-httpx =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest_httpx";
        version = "0.22.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "3a82797f3a9a14d51e8c6b7fa97524b68b847ee801109c062e696b4744f4431c";
          };
        propagatedBuildInputs = [httpx pytest];
        doCheck = false;
        meta = {
          description = "Send responses to httpx.";
          homepage = "https://colin-b.github.io/pytest_httpx/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pytest_httpx"];
      };

    pytest-sugar =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest-sugar";
        version = "0.9.7";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f1e74c1abfa55f7241cf7088032b6e378566f16b938f3f08905e2cf4494edd46";
          };
        propagatedBuildInputs = [pytest termcolor];
        doCheck = false;
        meta = {
          description = "pytest-sugar is a plugin for pytest that changes the default look and feel of pytest (e.g. progressbar, show tests that fail instantly).";
          homepage = "https://pivotfinland.com/pytest-sugar/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["pytest_sugar"];
      };

    pytest-xdist =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest-xdist";
        version = "3.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d42c9efb388da35480878ef4b2993704c6cea800c8bafbe85a8cdc461baf0748";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [execnet pytest];
        doCheck = false;
        meta = {
          description = "pytest xdist plugin for distributed testing, most importantly across multiple CPUs";
          homepage = "https://github.com/pytest-dev/pytest-xdist";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["xdist"];
      };

    python-box =
      python.pkgs.buildPythonPackage rec
      {
        pname = "python-box";
        version = "7.0.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "dc6724f88255ccbc07092abd506281439cc2b75c6569c754ffc2b22580e7ae06";
          };
        buildInputs = [cython];
        doCheck = false;
        meta = {
          description = "Advanced Python dictionaries with dot notation access";
          homepage = "https://github.com/cdgriffith/Box";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["box"];
      };

    python-dateutil =
      python.pkgs.buildPythonPackage rec
      {
        pname = "python-dateutil";
        version = "2.8.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [six];
        doCheck = false;
        meta = {
          description = "Extensions to the standard Python datetime module";
          homepage = "https://github.com/dateutil/dateutil";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["dateutil"];
      };

    python-lsp-black =
      python.pkgs.buildPythonPackage rec
      {
        pname = "python-lsp-black";
        version = "1.2.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d7eaeab2a377e96a82cc26afe2f8f2e1cf7c6eaefdcdeab026343e2e559dcce9";
          };
        propagatedBuildInputs = [black python-lsp-server toml];
        doCheck = false;
        meta = {
          description = "Black plugin for the Python LSP Server";
          homepage = "https://github.com/python-lsp/python-lsp-black";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pylsp_black"];
      };

    python-lsp-jsonrpc =
      python.pkgs.buildPythonPackage rec
      {
        pname = "python-lsp-jsonrpc";
        version = "1.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd";
          };
        propagatedBuildInputs = [ujson];
        doCheck = false;
        meta = {
          description = "JSON RPC 2.0 server library";
          homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
          license = "The MIT License (MIT)";
        };
        pythonImportsCheck = ["pylsp_jsonrpc"];
      };

    python-lsp-server =
      python.pkgs.buildPythonPackage rec
      {
        pname = "python-lsp-server";
        version = "1.7.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a31b0525be6ec831c7d2b476b744e5aa5074633e1d1b77ee97f332cde15983ea";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [
          docstring-to-markdown
          jedi
          pluggy
          python-lsp-jsonrpc
          setuptools
        ];
        doCheck = false;
        meta = {
          description = "Python Language Server for the Language Server Protocol";
          homepage = "https://github.com/python-lsp/python-lsp-server";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["pylsp"];
      };

    pyyaml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "PyYAML";
        version = "6.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2";
          };
        nativeBuildInputs = [cython setuptools];
        buildInputs = [pgen pkgs.libyaml];
        doCheck = false;
        meta = {
          description = "YAML parser and emitter for Python";
          homepage = "https://pyyaml.org/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["yaml"];
      };

    pyzmq =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pyzmq";
        version = "25.0.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6b8c1bbb70e868dc88801aa532cae6bd4e3b5233784692b786f17ad2962e5149";
          };
        nativeBuildInputs = [packaging setuptools];
        buildInputs = [pkgs.zeromq];
        doCheck = false;
        meta = {
          description = "Python bindings for 0MQ";
          homepage = "https://pyzmq.readthedocs.org";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["zmq"];
      };

    redis =
      python.pkgs.buildPythonPackage rec
      {
        pname = "redis";
        version = "4.5.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1eec3741cda408d3a5f84b78d089c8b8d895f21b3b050988351e925faf202864";
          };
        propagatedBuildInputs = [async-timeout];
        doCheck = false;
        meta = {
          description = "Python client for Redis database and key-value store";
          homepage = "https://github.com/redis/redis-py";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["redis"];
      };

    rustworkx =
      python.pkgs.buildPythonPackage rec
      {
        pname = "rustworkx";
        version = "0.13.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-AnbPC5iSEYWeh5e2fUwW7WrJ6zLttn4KR+cNfXHoBXQ=";
          };
        nativeBuildInputs = [
          pkgs.rustPlatform.cargoSetupHook
          pkgs.cargo
          pkgs.rustc
          setuptools-rust
        ];
        propagatedBuildInputs = [matplotlib];
        cargoDeps =
          pkgs.rustPlatform.importCargoLock
          {
            lockFile =
              pkgs.runCommand
              "${pname}-${version}-cargo-lock"
              {inherit src;}
              "tar -zxOf $src ${pname}-${version}/Cargo.lock > $out";
          };
        doCheck = false;
        meta = {
          description = "A python graph library implemented in Rust";
          homepage = "https://github.com/Qiskit/rustworkx";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["rustworkx"];
      };

    ruyaml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "ruyaml";
        version = "0.91.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6ce9de9f4d082d696d3bde264664d1bcdca8f5a9dff9d1a1f1a127969ab871ab";
          };
        nativeBuildInputs = [pip setuptools-scm setuptools-scm-git-archive];
        propagatedBuildInputs = [distro setuptools];
        doCheck = false;
        meta = {
          description = "ruyaml is a fork of ruamel.yaml";
          homepage = "https://github.com/pycontribs/ruyaml";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["ruyaml"];
      };

    semantic-version =
      python.pkgs.buildPythonPackage rec
      {
        pname = "semantic_version";
        version = "2.10.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c";
          };
        doCheck = false;
        meta = {
          description = "A library implementing the 'SemVer' scheme.";
          homepage = "https://github.com/rbarrois/python-semanticversion";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["semantic_version"];
      };

    sentinel-value =
      python.pkgs.buildPythonPackage rec
      {
        pname = "sentinel-value";
        version = "1.0.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2ff8e9e303c8f6abb2ad8c6d2615ed5f11061eeda2e51edfd560dc0567de633a";
          };
        nativeBuildInputs = [poetry-core];
        doCheck = false;
        meta = {
          description = "Sentinel Values - unique objects akin to None, True, False";
          homepage = "https://github.com/vdmit11/sentinel-value";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["sentinel_value"];
      };

    setupmeta =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setupmeta";
        version = "3.4.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f986a1d9c5b595a840d71d888950c7cc6bbb586b4145d04e7992501e280e07c3";
          };
        propagatedNativeBuildInputs = [pkgs.gitMinimal];
        doCheck = false;
        meta = {
          description = "Simplify your setup.py";
          homepage = "https://github.com/codrsquad/setupmeta";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["setupmeta"];
      };

    setuptools =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setuptools";
        version = "67.7.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f104fa03692a2602fa0fec6c6a9e63b6c8a968de13e17c026957dd1f53d80990";
          };
        doCheck = false;
        meta = {
          description = "Easily download, build, install, upgrade, and uninstall Python packages";
          homepage = "https://github.com/pypa/setuptools";
          license = pkgs.lib.licenses.mit;
        };
        pipInstallFlags = ["--ignore-installed"];
        pythonImportsCheck = ["pkg_resources" "setuptools"];
      };

    setuptools-rust =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setuptools-rust";
        version = "1.6.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "c86e734deac330597998bfbc08da45187e6b27837e23bd91eadb320732392262";
          };
        propagatedBuildInputs = [semantic-version setuptools typing-extensions];
        doCheck = false;
        meta = {
          description = "Setuptools Rust extension plugin";
          homepage = "https://github.com/PyO3/setuptools-rust";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["setuptools_rust"];
      };

    setuptools-scm =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setuptools_scm";
        version = "7.1.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6c508345a771aad7d56ebff0e70628bf2b0ec7573762be9960214730de278f27";
          };
        propagatedNativeBuildInputs = [pkgs.gitMinimal];
        propagatedBuildInputs = [packaging setuptools typing-extensions];
        doCheck = false;
        meta = {
          description = "the blessed package to manage your versions by scm tags";
          homepage = "https://github.com/pypa/setuptools_scm/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["setuptools_scm"];
      };

    setuptools-scm-git-archive =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setuptools_scm_git_archive";
        version = "1.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b048b27b32e1e76ec865b0caa4bb85df6ddbf4697d6909f567ac36709f6ef2f0";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "setuptools_scm plugin for git archives";
          homepage = "https://github.com/Changaco/setuptools_scm_git_archive/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["setuptools_scm_git_archive"];
      };

    six =
      python.pkgs.buildPythonPackage rec
      {
        pname = "six";
        version = "1.16.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926";
          };
        patchPhase = "sed -i 's/\\[pytest\\]/[tool:pytest]/' setup.cfg";
        doCheck = false;
        meta = {
          description = "Python 2 and 3 compatibility utilities";
          homepage = "https://github.com/benjaminp/six";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["six"];
      };

    snakeviz =
      python.pkgs.buildPythonPackage rec
      {
        pname = "snakeviz";
        version = "2.2.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "7bfd00be7ae147eb4a170a471578e1cd3f41f803238958b6b8efcf2c698a6aa9";
          };
        nativeBuildInputs = [setuptools];
        propagatedBuildInputs = [tornado];
        doCheck = false;
        meta = {
          description = "A web-based viewer for Python profiler output";
          homepage = "https://jiffyclub.github.io/snakeviz/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["snakeviz"];
      };

    sniffio =
      python.pkgs.buildPythonPackage rec
      {
        pname = "sniffio";
        version = "1.3.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101";
          };
        doCheck = false;
        meta = {
          description = "Sniff out which async library your code is running under";
          homepage = "https://github.com/python-trio/sniffio";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["sniffio"];
      };

    soupsieve =
      python.pkgs.buildPythonPackage rec
      {
        pname = "soupsieve";
        version = "2.4.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea";
          };
        nativeBuildInputs = [hatchling];
        doCheck = false;
        dontUsePythonImportsCheck = true;
        meta = {
          description = "A modern CSS selector implementation for Beautiful Soup.";
          homepage = "https://github.com/facelessuser/soupsieve";
          license = pkgs.lib.licenses.mit;
        };
      };

    termcolor =
      python.pkgs.buildPythonPackage rec
      {
        pname = "termcolor";
        version = "2.3.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a";
          };
        nativeBuildInputs = [hatch-vcs];
        doCheck = false;
        meta = {
          description = "ANSI color formatting for output in terminal";
          homepage = "https://github.com/termcolor/termcolor";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["termcolor"];
      };

    tinycss2 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "tinycss2";
        version = "1.2.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627";
          };
        nativeBuildInputs = [flit-core];
        propagatedBuildInputs = [webencodings];
        doCheck = false;
        meta = {
          description = "A tiny CSS parser";
          homepage = "https://www.courtbouillon.org/tinycss2";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["tinycss2"];
      };

    toml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "toml";
        version = "0.10.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f";
          };
        doCheck = false;
        meta = {
          description = "Python Library for Tom's Obvious, Minimal Language";
          homepage = "https://github.com/uiri/toml";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["toml"];
      };

    tornado =
      python.pkgs.buildPythonPackage rec
      {
        pname = "tornado";
        version = "6.3.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed.";
          homepage = "http://www.tornadoweb.org/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["tornado"];
      };

    tqdm =
      python.pkgs.buildPythonPackage rec
      {
        pname = "tqdm";
        version = "4.65.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "Fast, Extensible Progress Meter";
          homepage = "https://tqdm.github.io";
          license = pkgs.lib.licenses.mit;
        };
        patches = [
          (
            pkgs.fetchpatch
            {
              sha256 = "sha256-XZDI0+Ui8DnbStHkrpQPEhImRXrdFJ8mugRXQKB1YOw=";
              url = "https://github.com/tqdm/tqdm/pull/1333.patch";
            }
          )
        ];
        pythonImportsCheck = ["tqdm"];
      };

    traceback-with-variables =
      python.pkgs.buildPythonPackage rec
      {
        pname = "traceback-with-variables";
        version = "2.0.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a30c79b7c206fb255967f3f5d125ce114b3dae4fd92d268f901dd35ee23f9cc0";
          };
        doCheck = false;
        meta = {
          description = "Adds variables to python traceback. Simple, lightweight, controllable. Debug reasons of exceptions by logging or pretty printing colorful variable contexts for each frame in a stacktrace, showing every value. Dump locals environments after errors to console, files, and loggers. Works with Jupiter and IPython.";
          homepage = "https://github.com/andy-landy/traceback_with_variables";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["traceback_with_variables"];
      };

    traitlets =
      python.pkgs.buildPythonPackage rec
      {
        pname = "traitlets";
        version = "5.9.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f6cde21a9c68cf756af02035f72d5a723bf607e862e7be33ece505abf4a3bad9";
          };
        nativeBuildInputs = [hatchling];
        doCheck = false;
        meta = {
          description = "Traitlets Python configuration system";
          homepage = "https://github.com/ipython/traitlets";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["traitlets"];
      };

    trove-classifiers =
      python.pkgs.buildPythonPackage rec
      {
        pname = "trove-classifiers";
        version = "2023.5.2";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "c46d6e40a9581599b16c712e0164fec3764872a4085c673c07559787caedb867";
          };
        nativeBuildInputs = [calver setuptools];
        doCheck = false;
        meta = {
          description = "Canonical source for classifiers on PyPI (pypi.org).";
          homepage = "https://github.com/pypa/trove-classifiers";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["trove_classifiers"];
      };

    typeguard =
      python.pkgs.buildPythonPackage rec
      {
        pname = "typeguard";
        version = "2.13.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "Run-time type checker for Python";
          homepage = "https://github.com/agronholm/typeguard";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["typeguard"];
      };

    types-appdirs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-appdirs";
        version = "1.4.3.5";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "83268da64585361bfa291f8f506a209276212a0497bd37f0512a939b3d69ff14";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for appdirs";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["appdirs-stubs"];
      };

    types-attrs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types_attrs";
        version = "19.1.0";
        format = "wheel";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            inherit format;
            sha256 = "d11acf7a2531a7c52a740c30fa3eb8d01d3066c10d34c01ff5e59502caac5352";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for attrs";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["attr-stubs"];
      };

    types-docutils =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-docutils";
        version = "0.20.0.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "f682b5459a1e6e28208742adb0be8573d1ecbddd442f00d202b0278c1c4418a2";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for docutils";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
      };

    types-humanfriendly =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-humanfriendly";
        version = "10.0.1.9";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "3ab4334c40542efc06225f70eeb061f2f7e9cc14fe043c1ee04a94025162e341";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for humanfriendly";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["humanfriendly-stubs"];
      };

    types-psutil =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-psutil";
        version = "5.9.5.12";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "61a91679d3fe737250013b624dca09375e7cc3ad77dcc734553746c429c02aca";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for psutil";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["psutil-stubs"];
      };

    types-pygments =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-Pygments";
        version = "2.15.0.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "4fef924a4be98e4b0a3701f2822c33186cacd7dc317267853eaf451c3f361a97";
          };
        propagatedBuildInputs = [types-docutils types-setuptools];
        doCheck = false;
        meta = {
          description = "Typing stubs for Pygments";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["pygments-stubs"];
      };

    types-pyopenssl =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-pyOpenSSL";
        version = "23.1.0.3";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e7211088eff3e20d359888dedecb0994f7181d5cce0f26354dd47ca0484dc8a6";
          };
        propagatedBuildInputs = [cryptography];
        doCheck = false;
        meta = {
          description = "Typing stubs for pyOpenSSL";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["OpenSSL-stubs"];
      };

    types-pyyaml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-PyYAML";
        version = "6.0.12.9";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "c51b1bd6d99ddf0aa2884a7a328810ebf70a4262c292195d3f4f9a0005f9eeb6";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for PyYAML";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["yaml-stubs"];
      };

    types-redis =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-redis";
        version = "4.5.5.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2fe82f374d9dddf007deaf23d81fddcfd9523d9522bf11523c5c43bc5b27099e";
          };
        propagatedBuildInputs = [types-pyopenssl];
        doCheck = false;
        meta = {
          description = "Typing stubs for redis";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["redis-stubs"];
      };

    types-setuptools =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-setuptools";
        version = "67.7.0.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "155789e85e79d5682b0d341919d4beb6140408ae52bac922af25b54e36ab25c0";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for setuptools";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["pkg_resources-stubs" "setuptools-stubs"];
      };

    types-toml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-toml";
        version = "0.10.8.6";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "6d3ac79e36c9ee593c5d4fb33a50cca0e3adceb6ef5cff8b8e5aef67b4c4aaf2";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for toml";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["toml-stubs"];
      };

    types-tqdm =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-tqdm";
        version = "4.65.0.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "972dd871b6b2b8ff32f1f0f6fdfdf5a4ba2b0b848453689391bec8bd858fb1c4";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for tqdm";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["tqdm-stubs"];
      };

    types-typed-ast =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-typed-ast";
        version = "1.5.8.6";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "9543b5863db97b412a2b1d5f407c908336365a0bad304d64e8328a769f48c230";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for typed-ast";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["typed_ast-stubs"];
      };

    typing-extensions =
      python.pkgs.buildPythonPackage rec
      {
        pname = "typing_extensions";
        version = "4.5.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb";
          };
        nativeBuildInputs = [flit-core];
        doCheck = false;
        meta = {
          description = "Backported and Experimental Type Hints for Python 3.7+";
          homepage = "https://github.com/python/typing_extensions";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["typing_extensions"];
      };

    ujson =
      python.pkgs.buildPythonPackage rec
      {
        pname = "ujson";
        version = "5.7.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23";
          };
        nativeBuildInputs = [setuptools-scm];
        doCheck = false;
        meta = {
          description = "Ultra fast JSON encoder and decoder for Python";
          homepage = "https://github.com/ultrajson/ultrajson";
          license = pkgs.lib.licenses.bsdOriginal;
        };
      };

    uvloop =
      python.pkgs.buildPythonPackage rec
      {
        pname = "uvloop";
        version = "0.17.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "0ddf6baf9cf11a1a22c71487f39f15b2cf78eb5bde7e5b45fbb99e8a9d91b9e1";
          };
        patchPhase = "sed -i 's/~=/>=/g' setup.py";
        doCheck = false;
        meta = {
          description = "Fast implementation of asyncio event loop on top of libuv";
          homepage = "http://github.com/MagicStack/uvloop";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["uvloop"];
      };

    verboselogs =
      python.pkgs.buildPythonPackage rec
      {
        pname = "verboselogs";
        version = "1.7";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "e33ddedcdfdafcb3a174701150430b11b46ceb64c2a9a26198c76a156568e427";
          };
        doCheck = false;
        meta = {
          description = "Verbose logging level for Python's logging module";
          homepage = "https://verboselogs.readthedocs.io";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["verboselogs"];
      };

    virtualenv =
      python.pkgs.buildPythonPackage rec
      {
        pname = "virtualenv";
        version = "20.23.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a85caa554ced0c0afbd0d638e7e2d7b5f92d23478d05d17a76daeac8f279f924";
          };
        nativeBuildInputs = [hatch-vcs];
        propagatedBuildInputs = [distlib filelock platformdirs];
        doCheck = false;
        meta = {
          description = "Virtual Python Environment builder";
          homepage = "https://github.com/pypa/virtualenv";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["virtualenv"];
      };

    vulture =
      python.pkgs.buildPythonPackage rec
      {
        pname = "vulture";
        version = "2.7";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "67fb80a014ed9fdb599dd44bb96cb54311032a104106fc2e706ef7a6dad88032";
          };
        propagatedBuildInputs = [toml];
        doCheck = false;
        meta = {
          description = "Find dead code";
          homepage = "https://github.com/jendrikseipp/vulture";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["vulture"];
      };

    wcwidth =
      python.pkgs.buildPythonPackage rec
      {
        pname = "wcwidth";
        version = "0.2.6";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0";
          };
        doCheck = false;
        meta = {
          description = "Measures the displayed width of unicode strings in a terminal";
          homepage = "https://github.com/jquast/wcwidth";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["wcwidth"];
      };

    webencodings =
      python.pkgs.buildPythonPackage rec
      {
        pname = "webencodings";
        version = "0.5.1";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923";
          };
        doCheck = false;
        meta = {
          description = "Character encoding aliases for legacy web content";
          homepage = "https://github.com/SimonSapin/python-webencodings";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["webencodings"];
      };

    wheel =
      python.pkgs.buildPythonPackage rec
      {
        pname = "wheel";
        version = "0.40.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873";
          };
        nativeBuildInputs = [flit-core];
        patchPhase = "rm tests/test_macosx_libfile.py";
        doCheck = false;
        meta = {
          description = "A built-package format for Python";
          homepage = "https://github.com/pypa/wheel/issues";
          license = pkgs.lib.licenses.mit;
        };
        pipInstallFlags = ["--ignore-installed"];
        pythonImportsCheck = ["wheel"];
      };

    wmctrl =
      python.pkgs.buildPythonPackage rec
      {
        pname = "wmctrl";
        version = "0.4";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "66cbff72b0ca06a22ec3883ac3a4d7c41078bdae4fb7310f52951769b10e14e0";
          };
        doCheck = false;
        dontUsePythonImportsCheck = true;
        meta = {
          description = "A tool to programmatically control windows inside X";
          homepage = "https://github.com/antocuni/wmctrl";
          license = pkgs.lib.licenses.mit;
        };
      };

    wrapt =
      python.pkgs.buildPythonPackage rec
      {
        pname = "wrapt";
        version = "1.15.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a";
          };
        doCheck = false;
        meta = {
          description = "Module for decorators, wrappers and monkey patching.";
          homepage = "https://github.com/GrahamDumpleton/wrapt";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["wrapt"];
      };

    xmllayout =
      python.pkgs.buildPythonPackage rec
      {
        pname = "XMLLayout";
        version = "1.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "d5c0bb325f3030b67ec894fb83361da42cb87be544155917a9769d0e80d4e333";
          };
        patchPhase = ''
          sed -i "s/extra\['use_2to3'\] = True/pass/" setup.py
          2to3 --write --nobackups --no-diffs .
          sed -i 's/send(msg)/send(msg.encode("utf-8"))/' xmllayout/handlers.py
          sed -i -e 's/cgi/html/g' -e 's/LOG4J_LEVEL_MAP =.*/LOG4J_LEVEL_MAP = dict(CRITICAL="FATAL", WARNING="WARN", NOTICE="INFO", SPAM="TRACE")/' xmllayout/formatters.py
        '';
        doCheck = false;
        meta = {
          description = "Formats Python log messages as log4j XMLLayout XML";
          homepage = "http://pypi.python.org/pypi/XMLLayout";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["xmllayout"];
      };

    yamlfix =
      python.pkgs.buildPythonPackage rec
      {
        pname = "yamlfix";
        version = "1.9.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "dbf0873e1e409fa9e37e32c07ef74c1e93418392b1f952b4b5964adbe17cb402";
          };
        nativeBuildInputs = [pdm-pep517];
        propagatedBuildInputs = [maison ruyaml];
        doCheck = false;
        meta = {
          description = "A simple opionated yaml formatter that keeps your comments!";
          homepage = "https://github.com/lyz-code/yamlfix";
          license = pkgs.lib.licenses.gpl3Only;
        };
        pythonImportsCheck = ["yamlfix"];
      };

    yamllint =
      python.pkgs.buildPythonPackage rec
      {
        pname = "yamllint";
        version = "1.31.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "2d83f1d12f733e162a87e06b176149d7bb9c5bae4a9e5fce1c771d7f703f7a65";
          };
        nativeBuildInputs = [setuptools];
        propagatedBuildInputs = [pathspec pyyaml];
        doCheck = false;
        meta = {
          description = "A linter for YAML files.";
          homepage = "https://github.com/adrienverge/yamllint";
          license = pkgs.lib.licenses.gpl1Only;
        };
        pythonImportsCheck = ["yamllint"];
      };

    yappi =
      python.pkgs.buildPythonPackage rec
      {
        pname = "yappi";
        version = "1.4.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "504b5d8fc7433736cb5e257991d2e7f2946019174f1faec7b2fe947881a17fc0";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        meta = {
          description = "Yet Another Python Profiler";
          homepage = "https://github.com/sumerc/yappi";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["yappi"];
      };

    yarl =
      python.pkgs.buildPythonPackage rec
      {
        pname = "yarl";
        version = "1.9.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571";
          };
        propagatedBuildInputs = [idna multidict];
        doCheck = false;
        meta = {
          description = "Yet another URL library";
          homepage = "https://github.com/aio-libs/yarl/";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["yarl"];
      };
  }; (
    python.pkgs.buildPythonPackage rec
    {
      pname = "zerolib";
      version = "0.1.0.dev0";
      format = "pyproject";
      src =
        pkgs.nix-gitignore.gitignoreSource
        "/default.nix\n/dist-seed/\n/doc/\n/.*"
        (
          builtins.path
          {
            name = pname;
            path = ./.;
          }
        );
      nativeBuildInputs = [
        flit-core
        manhole
        pdbpp
        pip
        py-spy
        pyinstrument
        pytest-asyncio
        pytest-cov
        pytest-httpx
        pytest-sugar
        pytest-xdist
        toml
        types-appdirs
        types-attrs
        types-humanfriendly
        types-pygments
        types-pyyaml
        types-redis
        types-setuptools
        types-toml
        types-tqdm
        yappi
      ];
      propagatedNativeBuildInputs = [
        pkgs.gitMinimal
        pkgs.graphviz
        pkgs.rsync
        pkgs.xdg-utils
      ];
      propagatedBuildInputs = [
        aiofiles
        anyio
        atools
        contextvars-extras
        deepmerge
        loguru
        msgpack
        msgspec
        ptpython
        rustworkx
        tqdm
        wrapt
      ];
      catchConflicts = false;
      doCheck = false;
      meta = {
        description = "Build Nix derivations for Python packages";
        homepage = "https://github.com/0compute/nixipy";
        license = pkgs.lib.licenses.gpl3Plus;
      };
      preShellHook = "rm -rf *.dist-info *.egg-info";

      # Install editable with install cache in XDG_CACHE_HOME.
      shellHook = ''
        runHook preShellHook

        # Install editable to $XDG_CACHE_HOME keyed on $PWD and hash of pyproject.toml
        # and/or setup.{cfg,py}
        files=()
        for file in pyproject.toml setup.py setup.cfg; do
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

      pythonImportsCheck = ["nixipy"];
    }
  )
