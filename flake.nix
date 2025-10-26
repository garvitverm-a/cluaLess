{
  description = "cluaLess: C/C++ project manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        cluaLess = pkgs.luaPackages.buildLuarocksPackage {
          pname = "cluaLess";
          version = "0.1.0";

          src = ./.;

          knownRockspec = "${./cluaLess-0.1.0-1.rockspec}";
          propagatedBuildInputs = with pkgs.luaPackages; [
            luafilesystem
            inspect
          ];

          nativeBuildInputs = with pkgs; [ lua luarocks ];
          buildInputs = [ ];

          meta = {
            description =
              "cluaLess is a C/C++ project manager written in Lua, which allows describing the build in an abstract manner";
            # TODO: 
            # homepage = "";
            # license = pkgs.lib.licenses.mit;
            # maintainers = [ ];
          };
        };

      in {
        packages = {
          default = cluaLess;
          ${cluaLess.pname} = cluaLess;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              lua
              luarocks
              lua-language-server
              stylua

              cluaLess.propagatedBuildInputs or [ ]
            ] ++ cluaLess.buildInputs or [ ];

          shellHook = ''
            echo "Lua version: $(lua -v)"
            echo "Luarocks version: $(luarocks --version)"

            export LUAROCKS_CONFIG="$PWD/.luarocks/config.lua"
            export LUA_INIT="@$PWD/setup.lua"
          '';
        };
      });
}

