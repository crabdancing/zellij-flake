{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zellij = {
      url = "github:zellij-org/zellij";
      flake = false;
    };
  };

  outputs = { self, flake-utils, naersk, nixpkgs, zellij }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};
      in {
        # For `nix build` & `nix run`:
        defaultPackage = naersk'.buildPackage {
          src = zellij;
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo ];
        };
      }
    );
}

