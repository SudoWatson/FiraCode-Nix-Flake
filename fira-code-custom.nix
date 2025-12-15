{ pkgs ? import <nixpkgs> {} }:

(pkgs.callPackage ./fira-code-custom-derivation.nix {
  withFeatures = [ "ss02" "ss03" ];
})
