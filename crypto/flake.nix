{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            clang-tools_15
            clang_15
            python311
            virtualenv
            black
            ntl
            flint
            gcc
            gmp
            gdb
            gef
            valgrind
            massif-visualizer
            kcachegrind
            libllvm
            linuxPackages.perf
            cargo-flamegraph
          ]
          ++ (with pkgs.python311Packages; [
            pip
            sage
            numpy
            setuptools
          ]);
      };
    });
  };
}
