{
  lib,
  fetchFromGitHub,
  haskellPackages,
}:

let
  gititSrc = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "gitit";
    rev = "b0bf767aff50a9686b4663e33df2310f36cec87f";
    sha256 = "1i5bh963hjc4h86dmfvdgwsh628zfdqqxqfscr8l3b22g9jc2021";
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
