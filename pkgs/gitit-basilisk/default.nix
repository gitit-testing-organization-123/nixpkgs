{
  lib,
  fetchFromGitHub,
  haskellPackages,
}:

let
  gititSrc = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "gitit";
    rev = "b90cd54b9df09cfb79b9cd5409a3dbafd61f5303";
    sha256 = "1fnf714lky34gjn2c61r3wmqalgxy326l1syvr7rn5wfrs8pjpph";
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
