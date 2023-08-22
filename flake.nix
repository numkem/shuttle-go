{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = rec {
          default = shuttle-go;
          shuttle-go = pkgs.buildGoModule {
            name = "shuttle-go";

            src = ./.;

            vendorSha256 = "sha256-vwW+do+suS7gT0CkTEGdnIWlzWGJPZHhxEGgNGjIwS0=";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gopls
          ];
        };
      };
      flake = { };
    };
}
