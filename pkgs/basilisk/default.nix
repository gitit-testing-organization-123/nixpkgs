{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  gawk,
  bison,
  flex,
  glfw,
  libGL,
  cudaPackages,
  rocmPackages,
  gfortran,
  python3,
  swig,
  gnuplot,
  gifsicle,
  ffmpeg,
  imagemagick,
  glslSupport ? false,
  cudaSupport ? false,
  hipSupport ? false,
  pprSupport ? true,
  kdtSupport ? true,
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation {
  pname = "basilisk"
    + optionalString glslSupport "-glsl"
    + optionalString cudaSupport "-cuda"
    + optionalString hipSupport "-hip";

  version = "0.0.1";

  # Build the current source tree (this repo checkout)
  src = fetchFromGitHub {
    owner = "gitit-testing-organization-123";
    repo = "basilisk";
    rev = "53df21ab626f6698f99f01f444570c50764aa830";
    hash = "sha256-elmwYshXe89GgVS5iMP6L7uWApnH4FCG4Glu1kqnMGE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
    gawk
    bison
    flex
  ]
  ++ optional cudaSupport cudaPackages.cuda_nvcc
  ++ optional hipSupport rocmPackages.hipcc
  ++ optional pprSupport gfortran;

  buildInputs =
    optionals glslSupport [
      glfw
      libGL
    ]
    ++ optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
    ]
    ++ optionals hipSupport [
      rocmPackages.clr
    ];

  propagatedBuildInputs = [
    python3
    swig
    gnuplot
    ffmpeg
    imagemagick
    gifsicle
    stdenv.cc.cc.lib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ]
  ++ optional cudaSupport "-DBASILISK_USE_CUDA=ON"
  ++ optional glslSupport "-DBASILISK_USE_GLSL=ON"
  ++ optional hipSupport "-DBASILISK_USE_HIP=ON"
  ++ optional pprSupport "-DBASILISK_USE_PPR=ON"
  ++ optional kdtSupport "-DBASILISK_USE_KDT=ON";

  passthru = {
    inherit
      glslSupport
      cudaSupport
      hipSupport
      pprSupport
      kdtSupport
      ;
  };

  postInstall = ''
    wrapProgram "$out/bin/qcc" \
      --prefix PATH : ${lib.makeBinPath [
        python3
        swig
      ]} \
      --set PYTHONINCLUDE "${python3}/include/${python3.libPrefix}" \
      --set MDFLAGS "-fpic"
  '';

  meta = {
    description = "CMake build of the PacIFiC Basilisk source tree";
    homepage = "https://basilisk.fr";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    mainProgram = "qcc";
  };
}
