{
  lib,
  fetchFromGitHub,
  haskellPackages,
}:

let
  gititSrc = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "gitit";
    rev = "9f473a6facd53c6552ebb9ed17b53396109544c9";
    sha256 = "0p20s1ps7pjj71rvzlnnxzidwfr4nl3966wmj2rqb9ba0zk86kz2";
  };

  gitit = haskellPackages.callCabal2nix "gitit" gititSrc { };
in
gitit.overrideAttrs (old: {
  pname = "gitit-basilisk";

  postInstall = (old.postInstall or "") + ''
    ln -s "$out/bin/gitit" "$out/bin/gitit-basilisk"
  '';

  passthru = (old.passthru or { }) // {
    pluginModule = "Network.Gitit.Plugin.BasiliskLiterateC";
  };

  meta = (old.meta or { }) // {
    description = "Gitit with the Basilisk literate C renderer plugin";
    homepage = "https://github.com/gitit-testing-organization-123/gitit";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "gitit-basilisk";
  };
})
