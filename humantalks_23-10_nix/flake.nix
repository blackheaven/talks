{
  description = "Slides";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShell =
            let
              scripts = pkgs.symlinkJoin {
                name = "scripts";
                paths = pkgs.lib.mapAttrsToList pkgs.writeShellScriptBin {
                  buildSlides = ''
                    ${pkgs.pandoc}/bin/pandoc -t revealjs -s src.md -o out.html --slide-level 2 --variable theme="simple"
                  '';
                };
              };
            in
            pkgs.mkShell {
              buildInputs = [ scripts ];
            };
        });
}
