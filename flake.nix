{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

  flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system};
    let
      t = lib.trivial;
      hl = haskell.lib;

      name = "yesod-stubbing-example";

      project = devTools:
        let addBuildTools = (t.flip hl.addBuildTools) devTools;
        in haskellPackages.developPackage {
          root = lib.sourceFilesBySuffices ./. [ ".cabal" ".hs" ];
          name = name;
          returnShellEnv = !(devTools == [ ]);

          cabal2nixOptions =
            if builtins.getEnv "DEV" == "TRUE"
            then "--flag=dev"
            else "";

          modifier = (t.flip t.pipe) [
            addBuildTools
            hl.dontHaddock
            hl.enableStaticLibraries
            hl.justStaticExecutables
            hl.disableLibraryProfiling
            hl.disableExecutableProfiling
          ];
        };

    in {
      packages.pkg = project [ ];

      defaultPackage = self.packages.${system}.pkg;

      devShell = project (with haskellPackages; [
        cabal-fmt
        cabal-install
        hlint
      ]);

      shellHook = ''
        echo $DEV
      '';
    });
}
