# hello.nix
{
  lib,
  stdenv,
  fetchgit,
  patches ? null
}:
 # imports = [./serv-quark.nix];

stdenv.mkDerivation {
  pname = "quark-w-opt";
  version = "unstable-2022-08-16";

  installFlags = [ "DESTDIR=$(out)" ];
  src = fetchgit {
    url="git://git.suckless.org/quark";
    rev = "5ad0df91757fbc577ffceeca633725e962da345d";
    # sha256 = lib.fakeSha256;
    sha256 ="sha256-IQ1K70xAxdnt6fyguMnoA3L9THr20W8O0T38uDgVn0Q=";
  };
  meta = with lib; {
    description = "Extremely small and simple HTTP GET/HEAD-only web server for static content";
    logDescription = "This package aims to provide options to run a simplre wbeserver automatically without user interaction";
    homepage = "http://tools.suckless.org/quark";
    downloadPage = "https://git.suckless.org/quark/";
    license = licenses.isc;
    mainProgram = "quark";
    maintainers = with maintainers; [ Talleyrand-34 ];
    platforms = platforms.linux;
  };

}


