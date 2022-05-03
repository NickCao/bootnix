let
  seed = import ./seed.nix;
  mkDerivation = { name, builder, args }: derivation {
    inherit name builder args;
    system = "x86_64-linux";
  };
  # Phase-0 Rebuild hex0
  hex0 = mkDerivation {
    name = "hex0";
    builder = "${seed.bootstrap-seeds}/POSIX/AMD64/hex0-seed";
    args = [
      "${seed.stage0-posix-amd64}/hex0_AMD64.hex0"
      "${placeholder "out"}"
    ];
  };
  hex0Build = { name, src }: mkDerivation {
    inherit name;
    builder = "${hex0}";
    args = [
      src
      "${placeholder "out"}"
    ];
  };
  # Phase-1 Build hex1 from hex0
  hex1 = hex0Build {
    name = "hex1";
    src = "${seed.stage0-posix-amd64}/hex1_AMD64.hex0";
  };
  # Phase-1 Build catm from hex0
  catm = hex0Build {
    name = "catm";
    src = "${seed.stage0-posix-amd64}/catm_AMD64.hex0";
  };
  hex1Build = { name, src }: mkDerivation {
    inherit name;
    builder = "${hex1}";
    args = [
      src
      "${placeholder "out"}"
    ];
  };
  catmBuild = { name, srcs }: mkDerivation {
    inherit name;
    builder = "${catm}";
    args = [
      "${placeholder "out"}"
    ] ++ srcs;
  };
  # Phase-2 Build hex2 from hex1
  hex2-0 = hex1Build {
    name = "hex2-0";
    src = "${seed.stage0-posix-amd64}/hex2_AMD64.hex1";
  };
  hex2-0Build = { name, src }: mkDerivation {
    inherit name;
    builder = "${hex2-0}";
    args = [
      src
      "${placeholder "out"}"
    ];
  };
  # Phase-3 Build M0 from hex2
  M0-hex2 = catmBuild {
    name = "M0.hex2";
    srcs = [
      "${seed.stage0-posix-amd64}/ELF-amd64.hex2"
      "${seed.stage0-posix-amd64}/M0_AMD64.hex2"
    ];
  };
  M0 = hex2-0Build {
    name = "M0";
    src = "${M0-hex2}";
  };
  M0Build = { name, src }: mkDerivation {
    inherit name;
    builder = "${M0}";
    args = [
      src
      "${placeholder "out"}"
    ];
  };
  # Phase-4 Build cc_amd64 from M0
  cc_amd64-hex2 = M0Build {
    name = "cc_amd64.hex2";
    src = "${seed.stage0-posix-amd64}/cc_amd64.M1";
  };
  cc_amd64-0-hex2 = catmBuild {
    name = "cc_amd64-0.hex2";
    srcs = [
      "${seed.stage0-posix-amd64}/ELF-amd64.hex2"
      "${cc_amd64-hex2}"
    ];
  };
  cc_amd64 = hex2-0Build {
    name = "cc_amd64";
    src = "${cc_amd64-0-hex2}";
  };
  ccBuild = { name, src }: mkDerivation {
    inherit name;
    builder = "${cc_amd64}";
    args = [
      src
      "${placeholder "out"}"
    ];
  };
  # Phase-5 Build M2-Planet from cc_amd64
  M2-0-c = catmBuild {
    name = "M2-0.c";
    srcs = [
      "${seed.M2libc}/amd64/linux/bootstrap.c"
      "${seed.M2-Planet}/cc.h"
      "${seed.M2libc}/bootstrappable.c"
      "${seed.M2-Planet}/cc_globals.c"
      "${seed.M2-Planet}/cc_reader.c"
      "${seed.M2-Planet}/cc_strings.c"
      "${seed.M2-Planet}/cc_types.c"
      "${seed.M2-Planet}/cc_core.c"
      "${seed.M2-Planet}/cc_macro.c"
      "${seed.M2-Planet}/cc.c"
    ];
  };
  M2-0-M1 = ccBuild {
    name = "M2-0.M1";
    src = "${M2-0-c}";
  };
  M2-0-0-M1 = catmBuild {
    name = "M2-0-0.M1";
    srcs = [
      "${seed.stage0-posix-amd64}/amd64_defs.M1"
      "${seed.stage0-posix-amd64}/libc-core.M1"
      "${M2-0-M1}"
    ];
  };
  M2-0-hex2 = M0Build {
    name = "M2-0.hex2";
    src = "${M2-0-0-M1}";
  };
  M2-0-0-hex2 = catmBuild {
    name = "M2-0-0.hex2";
    srcs = [
      "${seed.stage0-posix-amd64}/ELF-amd64.hex2"
      "${M2-0-hex2}"
    ];
  };
  M2 = hex2-0Build {
    name = "M2";
    src = "${M2-0-0-hex2}";
  };
  M2Build = { name, args }: mkDerivation {
    name = "blood-elf-0.M1";
    builder = "${M2}";
    args = [
      "--architecture"
      "amd64"
      "-o"
      "${placeholder "out"}"
    ] ++ args;
  };
  # Phase-6 Build blood-elf-0 from C sources
  blood-elf-0-M1 = M2Build {
    name = "blood-elf-0.M1";
    args = [
      "-f"
      "${seed.M2libc}/amd64/linux/bootstrap.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/stringify.c"
      "-f"
      "${seed.mescc-tools}/blood-elf.c"
      "--bootstrap-mode"
    ];
  };
  blood-elf-0-0-M1 = catmBuild {
    name = "blood-elf-0-0.M1";
    srcs = [
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "${seed.M2libc}/amd64/libc-core.M1"
      "${blood-elf-0-M1}"
    ];
  };
  blood-elf-0-hex2 = M0Build {
    name = "blood-elf-0.hex2";
    src = "${blood-elf-0-0-M1}";
  };
  blood-elf-0-0-hex2 = catmBuild {
    name = "blood-elf-0-0.hex2";
    srcs = [
      "${seed.M2libc}/amd64/ELF-amd64.hex2"
      "${blood-elf-0-hex2}"
    ];
  };
  blood-elf-0 = hex2-0Build {
    name = "blood-elf-0";
    src = "${blood-elf-0-0-hex2}";
  };
  # Phase-7 Build M1-0 from C sources
  M1-macro-0-M1 = M2Build {
    name = "M1-macro-0.M1";
    args = [
      "-f"
      "${seed.M2libc}/amd64/linux/bootstrap.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/stringify.c"
      "-f"
      "${seed.mescc-tools}/M1-macro.c"
      "--bootstrap-mode"
      "--debug"
    ];
  };
  M1-macro-0-footer-M1 = mkDerivation {
    name = "M1-macro-0-footer.M1";
    builder = "${blood-elf-0}";
    args = [
      "--64"
      "--little-endian"
      "-f"
      "${M1-macro-0-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  M1-macro-0-0-M1 = catmBuild {
    name = "M1-macro-0-0.M1";
    srcs = [
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "${seed.M2libc}/amd64/libc-core.M1"
      "${M1-macro-0-M1}"
      "${M1-macro-0-footer-M1}"
    ];
  };
  M1-macro-0-hex2 = M0Build {
    name = "M1-macro-0.hex2";
    src = "${M1-macro-0-0-M1}";
  };
  M1-macro-0-0-hex2 = catmBuild {
    name = "M1-macro-0-0.hex2";
    srcs = [
      "${seed.M2libc}/amd64/ELF-amd64-debug.hex2"
      "${M1-macro-0-hex2}"
    ];
  };
  M1-0 = hex2-0Build {
    name = "M1-0";
    src = "${M1-macro-0-0-hex2}";
  };
  # Phase-8 Build hex2-1 from C sources
  hex2_linker-1-M1 = M2Build {
    name = "hex2_linker-1.M1";
    args = [
      "-f"
      "${seed.M2libc}/sys/types.h"
      "-f"
      "${seed.M2libc}/stddef.h"
      "-f"
      "${seed.M2libc}/amd64/linux/fcntl.c"
      "-f"
      "${seed.M2libc}/amd64/linux/unistd.c"
      "-f"
      "${seed.M2libc}/amd64/linux/sys/stat.c"
      "-f"
      "${seed.M2libc}/stdlib.c"
      "-f"
      "${seed.M2libc}/stdio.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/hex2.h"
      "-f"
      "${seed.mescc-tools}/hex2_linker.c"
      "-f"
      "${seed.mescc-tools}/hex2_word.c"
      "-f"
      "${seed.mescc-tools}/hex2.c"
      "--debug"
    ];
  };
  hex2_linker-1-footer-M1 = mkDerivation {
    name = "hex2_linker-1-footer.M1";
    builder = "${blood-elf-0}";
    args = [
      "--64"
      "--little-endian"
      "-f"
      "${hex2_linker-1-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  hex2_linker-1-hex2 = mkDerivation {
    name = "hex2_linker-1.hex2";
    builder = "${M1-0}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "-f"
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "-f"
      "${seed.M2libc}/amd64/libc-full.M1"
      "-f"
      "${hex2_linker-1-M1}"
      "-f"
      "${hex2_linker-1-footer-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  hex2_linker-1-0-hex2 = catmBuild {
    name = "hex2_linker-1-0.hex2";
    srcs = [
      "${seed.M2libc}/amd64/ELF-amd64-debug.hex2"
      "${hex2_linker-1-hex2}"
    ];
  };
  hex2-1 = hex2-0Build {
    name = "hex2-1";
    src = "${hex2_linker-1-0-hex2}";
  };
  # Phase-9 Build M1 from C sources
  M1-macro-1-M1 = M2Build {
    name = "M1-macro-1.M1";
    args = [
      "-f"
      "${seed.M2libc}/sys/types.h"
      "-f"
      "${seed.M2libc}/stddef.h"
      "-f"
      "${seed.M2libc}/amd64/linux/fcntl.c"
      "-f"
      "${seed.M2libc}/amd64/linux/unistd.c"
      "-f"
      "${seed.M2libc}/string.c"
      "-f"
      "${seed.M2libc}/stdlib.c"
      "-f"
      "${seed.M2libc}/stdio.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/stringify.c"
      "-f"
      "${seed.mescc-tools}/M1-macro.c"
      "--debug"
    ];
  };
  M1-macro-1-footer-M1 = mkDerivation {
    name = "M1-macro-1-footer.M1";
    builder = "${blood-elf-0}";
    args = [
      "--64"
      "--little-endian"
      "-f"
      "${M1-macro-1-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  M1-macro-1-hex2 = mkDerivation {
    name = "M1-macro-1.hex2";
    builder = "${M1-0}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "-f"
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "-f"
      "${seed.M2libc}/amd64/libc-full.M1"
      "-f"
      "${M1-macro-1-M1}"
      "-f"
      "${M1-macro-1-footer-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  M1 = mkDerivation {
    name = "M1";
    builder = "${hex2-1}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "--base-address"
      "0x00600000"
      "-f"
      "${seed.M2libc}/amd64/ELF-amd64-debug.hex2"
      "-f"
      "${M1-macro-1-hex2}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  # Phase-10 Build hex2 from C sources
  hex2_linker-2-M1 = M2Build {
    name = "hex2_linker-2.M1";
    args = [
      "-f"
      "${seed.M2libc}/sys/types.h"
      "-f"
      "${seed.M2libc}/stddef.h"
      "-f"
      "${seed.M2libc}/amd64/linux/fcntl.c"
      "-f"
      "${seed.M2libc}/amd64/linux/unistd.c"
      "-f"
      "${seed.M2libc}/amd64/linux/sys/stat.c"
      "-f"
      "${seed.M2libc}/stdlib.c"
      "-f"
      "${seed.M2libc}/stdio.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/hex2.h"
      "-f"
      "${seed.mescc-tools}/hex2_linker.c"
      "-f"
      "${seed.mescc-tools}/hex2_word.c"
      "-f"
      "${seed.mescc-tools}/hex2.c"
      "--debug"
    ];
  };
  hex2_linker-2-footer-M1 = mkDerivation {
    name = "hex2_linker-2-footer.M1";
    builder = "${blood-elf-0}";
    args = [
      "--64"
      "--little-endian"
      "-f"
      "${hex2_linker-2-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  hex2_linker-2-hex2 = mkDerivation {
    name = "hex2_linker-2.hex2";
    builder = "${M1}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "-f"
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "-f"
      "${seed.M2libc}/amd64/libc-full.M1"
      "-f"
      "${hex2_linker-2-M1}"
      "-f"
      "${hex2_linker-2-footer-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  hex2 = mkDerivation {
    name = "hex2";
    builder = "${hex2-1}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "--base-address"
      "0x00600000"
      "-f"
      "${seed.M2libc}/amd64/ELF-amd64-debug.hex2"
      "-f"
      "${hex2_linker-2-hex2}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  # Phase-11 Build kaem from C sources
  kaem-M1 = M2Build {
    name = "kaem.M1";
    args = [
      "-f"
      "${seed.M2libc}/sys/types.h"
      "-f"
      "${seed.M2libc}/stddef.h"
      "-f"
      "${seed.M2libc}/string.c"
      "-f"
      "${seed.M2libc}/amd64/linux/fcntl.c"
      "-f"
      "${seed.M2libc}/amd64/linux/unistd.c"
      "-f"
      "${seed.M2libc}/stdlib.c"
      "-f"
      "${seed.M2libc}/stdio.c"
      "-f"
      "${seed.M2libc}/bootstrappable.c"
      "-f"
      "${seed.mescc-tools}/Kaem/kaem.h"
      "-f"
      "${seed.mescc-tools}/Kaem/variable.c"
      "-f"
      "${seed.mescc-tools}/Kaem/kaem_globals.c"
      "-f"
      "${seed.mescc-tools}/Kaem/kaem.c"
      "--debug"
    ];
  };
  kaem-footer-M1 = mkDerivation {
    name = "kaem-footer.M1";
    builder = "${blood-elf-0}";
    args = [
      "--64"
      "--little-endian"
      "-f"
      "${kaem-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  kaem-hex2 = mkDerivation {
    name = "kaem.hex2";
    builder = "${M1}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "-f"
      "${seed.M2libc}/amd64/amd64_defs.M1"
      "-f"
      "${seed.M2libc}/amd64/libc-full.M1"
      "-f"
      "${kaem-M1}"
      "-f"
      "${kaem-footer-M1}"
      "-o"
      "${placeholder "out"}"
    ];
  };
  kaem = mkDerivation {
    name = "kaem";
    builder = "${hex2}";
    args = [
      "--architecture"
      "amd64"
      "--little-endian"
      "--base-address"
      "0x00600000"
      "-f"
      "${seed.M2libc}/amd64/ELF-amd64-debug.hex2"
      "-f"
      "${kaem-hex2}"
      "-o"
      "${placeholder "out"}"
    ];
  };
in
{
  inherit M1 M2 blood-elf-0 hex2 kaem;
}
