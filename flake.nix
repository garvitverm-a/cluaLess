{
  description = "clualess: C/C++ project manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        clualess = pkgs.luaPackages.buildLuarocksPackage {
          pname = "clualess";
          version = "0.1.0";

          src = ./.;

          knownRockspec = "${./clualess-0.1.0-1.rockspec}";
          propagatedBuildInputs = with pkgs.luaPackages; [
            luafilesystem
            inspect
          ];

          nativeBuildInputs = with pkgs; [ lua luarocks ];
          buildInputs = [ ];

          meta = {
            description =
              "clualess is a C/C++ project manager written in Lua, which allows describing the build in an abstract manner";
            # TODO: 
            homepage = "https://github.com/garvitverm-a/clualess";
            # license = pkgs.lib.licenses.mit;
            # maintainers = [ ];
          };
        };

      in {
        packages = {
          default = clualess;
          ${clualess.pname} = clualess;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              lua
              luarocks
              lua-language-server
              stylua

              clualess.propagatedBuildInputs or [ ]
            ] ++ clualess.buildInputs or [ ];

          shellHook = ''
            echo "Lua version: $(lua -v)"
            echo "Luarocks version: $(luarocks --version)"

            export LUAROCKS_CONFIG="$PWD/.luarocks/config.lua"
            export LUA_INIT="@$PWD/setup.lua"
          '';
        };
      });
}

