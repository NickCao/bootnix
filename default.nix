let
  seed = import ./seed.nix;
  stage1 = import ./stage1.nix;
in
derivation {
  name = "mes";
  system = "x86_64-linux";
  builder = "${stage1}/bin/kaem";
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./mes.kaem
  ];
  src = "${seed.mes}";
  PATH = "${stage1}/bin";
  NYACC = "${seed.nyacc}";
  SUPPORT = ./mes;
}
