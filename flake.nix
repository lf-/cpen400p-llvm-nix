{
  description = "Example flake which just gives you a dev shell with yarn";
  inputs = {
    nixpkgs.url = "github:lf-/nixpkgs/jade/update-afl";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      out = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };

          klee13 = pkgs.klee.override {
            llvm = pkgs.llvm_13;
            clang = pkgs.clang_13;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              llvmPackages_13.llvm
              clang-tools_13
              clang_13
              libxml2
              cmake
              ninja
              z3
              klee13
              aflplusplus
            ];
          };

        };
    in
    flake-utils.lib.eachDefaultSystem out // {
      overlays.default = final: prev: { };
    };

}
