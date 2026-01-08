{ lib
, stdenv
, fetchFromGitHub
, python3
, fontforge
, ttfautohint
, brotli
, woff2
, git
, pkgs
, withFeatures ? [ ]
, fontWeights ? [ ]
, fontFamilyName ? "features"
}:

let
  featureList = lib.concatStringsSep "," withFeatures;
  weightList = lib.concatStringsSep "," fontWeights;

in
stdenv.mkDerivation {
  pname = "fira-code-custom";
  version = "6.2";

  src = fetchFromGitHub {
    owner  = "tonsky";
    repo   = "FiraCode";
    # rev   = "4a42ee8";
    rev    = "6ec202a";  # The last commit that builds. Later commits suffer from a mac specific sed error I think
    sha256 = "sha256-lyAdC8xsz0mkjiO5mmYjvFc3KevL0M9cDKRiK0ly+1o=";
  };

  nativeBuildInputs = [
    git
    (python3.withPackages (ps: [  # TODO: Some of these are not needed
      ps.fonttools
      ps.fontmake
      ps.glyphslib
      ps.ufolib2
      ps.defcon
      ps.afdko
      ps.gftools
    ]))
    ttfautohint
    brotli
    woff2
    pkgs.haskellPackages.sfnt2woff
  ];

  postPatch = ''
    patchShebangs script

    # TODO: Is this still needed? Or is this fixed without the mac sed error above?
    substituteInPlace script/build.sh \
    --replace "sed -i \'\'" "sed -i"
  '';

  HOME = "$TMPDIR";
  GIT_CONFIG_GLOBAL = "/dev/null";

  buildPhase = ''
    # Symlink `sfnt2woff` as the zopfli varient, as it's unavailable on nix and I don't want to package it
    mkdir -p $TMPDIR/bin
    ln -s ${pkgs.haskellPackages.sfnt2woff}/bin/sfnt2woff $TMPDIR/bin/sfnt2woff-zopfli
    export PATH=$TMPDIR/bin:$PATH
    # Make Google Font Tools use Python version of something. Takes longer to build but doesn't really take that much longer compared to not building.
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

    ./script/build.sh \
      -n "${fontFamilyName}" \
      ${lib.optionalString (withFeatures != []) "-f \"${featureList}\"\\"}
      ${lib.optionalString (fontWeights != []) "-w \"${weightList}\""}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/{truetype,opentype}
    cp distr/ttf/*/*.ttf $out/share/fonts/truetype/
    cp distr/otf/*/*.otf $out/share/fonts/opentype/
  '';

  meta = with lib; {
    description = "Fira Code built with selected OpenType features";
    homepage = "https://github.com/tonsky/FiraCode";
    platforms = platforms.linux;
  };
}
