{
  description = "C++ application description";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  };

  outputs = { self, nixpkgs }:
    let
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system:
          function (import nixpkgs {
            inherit system;
            overlays = [ ];
            config = { };
          }));

    in rec {
      packages = forAllSystems (pkgs: rec {
        redPandaTemplateApp = with pkgs;
          stdenv.mkDerivation {
            name = "redPandaTemplateApp";
            version = "0.0.1";

            src = lib.cleanSource ./.;

            nativeBuildInputs = [ cmake ninja gtest ]
              ++ lib.optionals (stdenv.isDarwin) [ lldb ]
              ++ lib.optionals (stdenv.isLinux) [ gdb ];

            buildInputs = [ spdlog ];

            devInputs = [
              clang-tools
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              cpplint
              vcpkg
              vcpkg-tool
            ];
          };

        redPandaTemplateApptest = redPandaTemplateApp.overrideAttrs (oldAttrs: {
          doCheck = true;
          cmakeFlags = [ "-DENABLE_TESTING=ON" ];
        });

        default = redPandaTemplateApp;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = [
            packages."${pkgs.system}".redPandaTemplateApp.nativeBuildInputs
            packages."${pkgs.system}".redPandaTemplateApp.buildInputs
            packages."${pkgs.system}".redPandaTemplateApp.devInputs
          ];
        };
      });

    };
}
