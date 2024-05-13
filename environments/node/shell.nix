let
  pkgs = import <nixpkgs> {};
in 
  pkgs.mkShell {
    packages = [ pkgs.nodejs ];
    shellHook = '' 
      export NODE_OPTIONS="--no-warnings"
      export PATH="node_modules/.bin:$PATH"
    '';
  }
