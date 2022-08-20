{
  description =
    "A Nix-flake-based development environment for Terraform, Packer, and Nomad";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (pkgs)
          damon levant mkShell nomad nomad-autoscaler nomad-pack packer
          terraform vault;

        hashiTools = [
          packer
          terraform
          nomad
          vault
          nomad-autoscaler
          nomad-pack
          levant
          damon
        ];

        relatedTools = with pkgs; [ terragrunt ];
      in {
        devShells = {
          default = mkShell {
            buildInputs = hashiTools ++ relatedTools;

            shellHook = ''
              echo "packer `${packer}/bin/packer --version`"
              ${terraform}/bin/terraform --version
              ${nomad}/bin/nomad --version
              ${vault}/bin/vault --version
            '';
          };
        };
      });
}
