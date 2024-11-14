{pkgs}: let
  python = pkgs.python311;
  pypkgs = rec {
    inherit (python.pkgs) setuptools;

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

    beartype =
      python.pkgs.buildPythonPackage rec
      {
        pname = "beartype";
        version = "0.16.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-GtqJzy1usw624Vbu0utUkzV3gpN5ENdDgJGOU8Lq4L8=";
          };
        nativeBuildInputs = [setuptools];
        doCheck = false;
        pythonImportsCheck = ["beartype"];
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
        version = "7.6.4";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-KfwPF7HT/qMy+AAdRVj4IUr38dh6NF86EzyQHWA0fHM=";
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

    cython2 =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Cython";
        version = "0.29.36";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-QcDP0tdU44PJ7rle/8mqSrhH0Ml0cHfd18Dctow7wB8=";
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

    cython =
      python.pkgs.buildPythonPackage rec
      {
        pname = "Cython";
        version = "3.0.5";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-OTGDSNtIii8k58hOCL3ILyYkhTwP6otHXqC3CycXZJI=";
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

    msgpack =
      python.pkgs.buildPythonPackage rec
      {
        pname = "msgpack";
        version = "1.0.7";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-Vy78k9t6TSfkBFAZdcptLZd1cFwtkiOQ2Hj892jZLIc=";
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
        version = "0.18.6";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-pZ/DtPzbly0JE4y1FtveYAyZ0Hw4/ZNypu9QDS0DG04=";
          };
        doCheck = false;
        meta = {
          description = "A fast serialization and validation library, with builtin support for JSON, MessagePack, YAML, and TOML.";
          homepage = "https://jcristharif.com/msgspec/";
          license = pkgs.lib.licenses.bsdOriginal;
        };
        pythonImportsCheck = ["msgspec"];
      };

    mypy = python.pkgs.buildPythonPackage rec {
      pname = "mypy";
      version = "1.13.0";
      format = "pyproject";
      src = python.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "sha256-ApGmG2+/PmZz40Bc/MDnZQvrx5OWWf3KJwKVgDi9g14=";
      };
      nativeBuildInputs = [
        setuptools
        types-psutil
        types-setuptools
        types-typed-ast
      ];
      propagatedBuildInputs = [
        mypy-extensions
        psutil
        typing-extensions
      ];
      doCheck = false;
      meta = {
        description = "Optional static typing for Python";
        homepage = "https://www.mypy-lang.org/";
        license = pkgs.lib.licenses.mit;
      };
      pythonImportsCheck = [
        "mypy"
        "mypyc"
      ];
      MYPY_USE_MYPYC = "1";
    };

    mypy-extensions = python.pkgs.buildPythonPackage rec {
      pname = "mypy_extensions";
      version = "1.0.0";
      src = python.pkgs.fetchPypi {
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
        nativeBuildInputs = [cython2 pkgs.gfortran];
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

    pluggy =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pluggy";
        version = "1.5.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-LP+ojpT9yXjExXTxX55Zt/QgHUORlcNxXKniSG8dDPE=";
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

    psutil = python.pkgs.buildPythonPackage rec {
      pname = "psutil";
      version = "5.9.6";
      format = "pyproject";
      src = python.pkgs.fetchPypi {
        inherit pname;
        inherit version;
        sha256 = "sha256-5Lkt3NfdTN0/kAGA6h4QSTLHvOI0+4iXbio7KWRBIlo=";
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

    pytest =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest";
        version = "8.3.3";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-cLmBB71kgwinlSsG5sqaULxmC+IY1TwlfMH8lP2hAYE=";
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
        pname = "pytest_asyncio";
        version = "0.24.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-0IHYKOV22F+HU5kZQoHpK/imjWDXLRovry/t22xGsnY=";
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
        version = "6.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-/eC1lcoki7ji128CC0ZfOxB8ljLmodFwXxeDTIncrcA=";
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

    pytest-random-order =
      python.pkgs.buildPythonPackage
      rec {
        pname = "pytest-random-order";
        version = "1.1.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "dbe6debb9353a7af984cc9eddbeb3577dd4dbbcc1529a79e3d21f68ed9b45605";
          };
        propagatedBuildInputs = [pytest];
        doCheck = false;
        meta = {
          description = "Randomise the order in which pytest tests are run with some control over the randomness";
          homepage = "https://github.com/jbasko/pytest-random-order";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["random_order"];
      };

    pytest-sugar =
      python.pkgs.buildPythonPackage rec
      {
        pname = "pytest-sugar";
        version = "1.0.0";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-ZCLoMlj1sMBM58YyF2x3Msq1/bkJyznMpckTn4EnbAo=";
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

    pyyaml =
      python.pkgs.buildPythonPackage rec
      {
        pname = "PyYAML";
        version = "6.0.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-v99GCxc2x3Xyup9qkryjC8IJUGe4qdd4dtH61sw7SkM=";
          };
        nativeBuildInputs = [cython2 setuptools];
        buildInputs = [pgen pkgs.libyaml];
        doCheck = false;
        meta = {
          description = "YAML parser and emitter for Python";
          homepage = "https://pyyaml.org/";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["yaml"];
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

    setuptools-rust =
      python.pkgs.buildPythonPackage rec
      {
        pname = "setuptools-rust";
        version = "1.8.1";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-lLHdXVMIsxONW5M8OitV5taSfRoiYy5Qn86p3dD35IY=";
          };
        propagatedBuildInputs = [semantic-version setuptools setuptools-scm typing-extensions];
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
        version = "4.1.5";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-6goRO7wRG8/8kHieuyFWJcljQR9wlqfpBi1ORjDBVf0=";
          };
        nativeBuildInputs = [setuptools-scm];
        propagatedBuildInputs = [typing-extensions];
        doCheck = false;
        meta = {
          description = "Run-time type checker for Python";
          homepage = "https://github.com/agronholm/typeguard";
          license = pkgs.lib.licenses.mit;
        };
        pythonImportsCheck = ["typeguard"];
      };

    types-aiofiles =
      python.pkgs.buildPythonPackage rec
      {
        pname = "types-aiofiles";
        version = "23.1.0.2";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "ea0a659f7cdd689a65a4e56170299d5d3c848b46984789b5302567f843a51462";
          };
        doCheck = false;
        meta = {
          description = "Typing stubs for aiofiles";
          homepage = "https://github.com/python/typeshed";
          license = pkgs.lib.licenses.asl20;
        };
        pythonImportsCheck = ["aiofiles-stubs"];
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
        version = "4.8.0";
        format = "pyproject";
        src =
          python.pkgs.fetchPypi
          {
            inherit pname;
            inherit version;
            sha256 = "sha256-345DOenLdzV1WMvbzsozwwNxTPhh0e7xXhBwBVrot+8=";
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
  };
in
  with pypkgs; (
    python.pkgs.buildPythonPackage rec
    {
      pname = "zerolib";
      version = "0.1.0.dev0";
      format = "pyproject";
      src =
        pkgs.nix-gitignore.gitignoreSource
        "/*.nix"
        (
          builtins.path
          {
            name = pname;
            path = ./.;
          }
        );
      nativeBuildInputs = [
        beartype
        flit-core
        mypy
        pdbpp
        pip # because we're using a custom shellHook
        ptpython
        pytest-asyncio
        pytest-cov
        pytest-random-order
        pytest-sugar
        typeguard
        types-aiofiles
        types-appdirs
        types-pyyaml
      ];
      propagatedNativeBuildInputs = [
        pkgs.graphviz
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
        pyyaml
        rustworkx
        wrapt
      ];
      catchConflicts = false;
      doCheck = false;
      preShellHook = "rm -rf *.dist-info *.egg-info";

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

      pythonImportsCheck = ["zerolib"];
      passthru.pypkgs = pypkgs;
    }
  )
