{
  stdenvNoCC,
  fetchFromGitLab,
  installFonts,
}:
stdenvNoCC.mkDerivation {
  pname = "lotion";
  version = "1.0";
  outputs = ["out"];

  src = fetchFromGitLab {
    owner = "nefertiti";
    repo = "lotion-dist";
    rev = "eca92f34baf5ad7535602ac640bb9d45d0a2db07";
    hash = "sha256-N81xpN0GFqk8Mr01fpNSo5KYx513PxCGC4OvFJDd2fM=";
  };

  nativeBuildInputs = [ installFonts ];
}
