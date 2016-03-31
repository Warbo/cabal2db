{ runScript, c2db-scripts }:
pkgDir:

runScript {
    inherit pkgDir;
    buildInputs = [ c2db-scripts ];

    # Required for calling nix-shell during build
    NIX_REMOTE = "daemon";
    NIX_PATH   = builtins.getEnv "NIX_PATH";

    # Allows ~/.nixpkgs to be used during debug
    HOME=builtins.getEnv "HOME";
  }
  ''
    cp -rv "$pkgDir" ./pkgDir
    chmod +w -R pkgDir

    dump-package "$(readlink -f pkgDir)" > dump.json

    RESULT=$(nix-store --add dump.json)
    printf '%s' "$RESULT" > "$out"
  ''
