{
  description = "RazerCommander flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        razercommander = pkgs.python3Packages.buildPythonPackage rec {
          pname = "razercommander";
          version = "1.2.1.2";
          format = "other";
          src = pkgs.fetchFromGitLab {
            owner = "GabMus";
            repo = "razerCommander";
            rev = "1.2.1.2";
            hash = "sha256-NiLKui1GfEqb5MfsWZ9SYuwLQLCf67sn8tMKy9yk3mw=";
          };
          build-system = with pkgs; [
            ninja
            meson
            pkg-config
          ];
          nativeBuildInputs = with pkgs; [
            glib
            appstream-glib
            desktop-file-utils
            gtk3
            wrapGAppsHook3
          ];
          buildInputs = with pkgs; [
            gobject-introspection
            python3
            openrazer-daemon
          ];
          dontWrapGApps = true;
          propagatedBuildInputs = with pkgs.python311Packages; [ pygobject3 ];
          preInstall = ''
            makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
          '';

          buildPhase = ''
            meson setup  
            meson compile
          '';
          installPhase = ''ninja install'';
        };
      in
      {
        packages = {
          inherit razercommander;
          default = razercommander;
        };
      }
    );
}
