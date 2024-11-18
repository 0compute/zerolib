{ lib }:
{

  override =
    super: pname: version: hash:
    let
      pkg = super.${pname};
    in
    assert lib.assertMsg (
      builtins.compareVersions pkg.version version == -1
    ) "refusing to downgrade ${pname} ${pkg.version} to ${version}";
    pkg.overridePythonAttrs {
      inherit version;
      src = super.fetchPypi { inherit pname version hash; };
    };

}
