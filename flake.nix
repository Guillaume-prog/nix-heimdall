{
  description = "Heimdall flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    _version = "2.1.0";

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system}.default = pkgs.stdenv.mkDerivation rec {
      pname = "heimdall";
      version = _version;
      src = builtins.fetchTarball {
        url = "https://git.sr.ht/~grimler/Heimdall/archive/v${_version}.tar.gz";
        sha256 = "sha256:121fxs0l4j4n1b4lcp930m8n3aj9b1xl5dhzcllh260l0xbr9lz2";
      };

      nativeBuildInputs = with pkgs; [ 
        cmake
        qt5.wrapQtAppsHook
      ];

      buildInputs = with pkgs; [
        gcc
        gnumake
        libusb1
        qt5.qtbase
        zlib
      ];

      buildPhase = ''
        cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out
        make
      '';

      installPhase = ''
        mkdir -p $out/bin
        make install
      '';

      meta = with pkgs.lib; {
        description = "A cross-platform open-source tool suite used to flash firmware onto Samsung mobile devices.";
        homepage = "https://git.sr.ht/~grimler/Heimdall";
        license = licenses.mit;
        maintainers = [ maintainers.Guillaume-prog ]; # Add your GitHub username here
        platforms = platforms.linux;
      };
    };
  };
}