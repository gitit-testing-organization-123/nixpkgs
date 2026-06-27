{
  lib,
  fetchFromGitHub,
  haskellPackages,
}:

let
  gititSrc = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "gitit";
    rev = "38e8b18f7aa260eedbb77352b2c680d1c0b469cf";
    sha256 = "18mwn1gzjmi1w8lm0hi3rz06459an3p7zwl81vs5lhqjy5d7zki3";
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
