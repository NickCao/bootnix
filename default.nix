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
    (builtins.toFile "run.kaem" ''
      set -ex
      cp ''${src} mes.tar.gz
      ungz mes.tar.gz
      untar mes.tar
      cd mes-0.24/
      cp mes/module/srfi/srfi-9-struct.mes mes/module/srfi/srfi-9.mes
      cp mes/module/srfi/srfi-9/gnu-struct.mes mes/module/srfi/srfi-9/gnu.mes
      cp lib/tests/dirent/readdir.dir/file lib/tests/dirent/readdir.dir/link
      kaem --verbose --strict --file kaem.run
      mkdir ''${out}
      mkdir ''${out}/bin
      cp bin/mes ''${out}/bin/mes
      chmod 0755 ''${out}/bin/mes
    '')
  ];
  src = "${seed.mes}";
  PATH = "${stage1}/bin";
}
