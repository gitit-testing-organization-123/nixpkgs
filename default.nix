# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays
 
  basilisk = pkgs.callPackage ./pkgs/basilisk { };
  basilisk-glsl = pkgs.callPackage ./pkgs/basilisk { glslSupport = true; };
  basilisk-cuda = pkgs.callPackage ./pkgs/basilisk { cudaSupport = true; };
  basilisk-hip = pkgs.callPackage ./pkgs/basilisk { hipSupport = true; };

  gitit-basilisk = pkgs.callPackage ./pkgs/gitit-basilisk { };

  # example-package = pkgs.callPackage ./pkgs/example-package { };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
