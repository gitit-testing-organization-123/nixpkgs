{
  lib,
  fetchFromGitHub,
  haskellPackages,
}:

let
  gititSrc = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "gitit";
    rev = "b4aff5e43fb7cb8724e567fd4e6fa6a008a04541";
    sha256 = "1x9zrgj3wfa00qvnly3j4xws1phh0nz3npgqmm347xrvr1cqmk14";
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
