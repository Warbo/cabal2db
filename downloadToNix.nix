{ stdenv, haskellPackages }:
pkgName:

stdenv.mkDerivation {
  inherit pkgName;
  name        = "download-to-nix-${pkgName}";
  buildInputs = [ haskellPackages.cabal-install ];

  # Required for calling nix-shell during build
  NIX_REMOTE = "daemon";
  NIX_PATH   = builtins.getEnv "NIX_PATH";

  # Download pkgName to the store
  builder = builtins.toFile "download-to-nix-builder" ''
    source "$stdenv/setup"

    DELETEME=$(mktemp -d --tmpdir "download-to-nix-XXXXX")
    cd "$DELETEME"

    export HOME="$TMPDIR"
    cabal update
    cabal get "$pkgName" || exit 1
    for D in ./*
    # */
    do
      mv "$D" "$out"
      break
    done

    cd "$out"
    rm -rf "$DELETEME"
  '';
}
