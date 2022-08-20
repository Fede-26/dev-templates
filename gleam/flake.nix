{
  description = "A Nix-flake-based Gleam development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        gleamPkg = pkgs.gleam;

        inherit (pkgs) mkShell;
      in {
        devShells = {
          default = mkShell {
            buildInputs = [ gleamPkg ];

            shellHook = ''
              ${gleamPkg}/bin/gleam --version
            '';
          };
        };
      });
}
