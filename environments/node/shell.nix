let
  pkgs = import <nixpkgs> {};
in 
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [ nodejs ];
    buildInputs = with pkgs.buildPackages; [ ];
    shellHook = '' 
      export PATH="node_modules/.bin:$PATH"
    '';
  }
