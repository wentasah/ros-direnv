{
  description = "ros-direnv";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "ros-direnv";
            version = self.lastModifiedDate;
            src = ./.;
            installFlags = [ "PREFIX=${placeholder "out"}" ];
          };
        };
      }
    );
}
