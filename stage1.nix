let
  seed = import ./seed.nix;
  stage0 = import ./stage0.nix;
  full = derivation {
    name = "full";
    system = "x86_64-linux";
    builder = "${stage0.kaem}";
    args = [
      "--verbose"
      "--strict"
      "--file"
      ./mescc-tools-full-kaem.kaem
    ];
    M1 = stage0.M1;
    M2 = stage0.M2;
    HEX2 = stage0.hex2;
    M2MESOPLANET = seed.M2-Mesoplanet;
    M2PLANET = seed.M2-Planet;
    MESCCTOOLS = seed.mescc-tools;
    BLOODELF0 = stage0.blood-elf-0;
    ARCH = "amd64";
    ARCH_DIR = "AMD64";
    M2LIBC = "${seed.M2libc}";
    BLOOD_FLAG = "--64";
    BASE_ADDRESS = "0x00600000";
    ENDIAN_FLAG = "--little-endian";
    outputs = [ "M2MESOPLANET_BIN" "M2PLANET_BIN" "BLOODELF" "GETMACHINE" ];
  };
  extra = derivation {
    name = "extra";
    system = "x86_64-linux";
    builder = "${stage0.kaem}";
    args = [
      "--verbose"
      "--strict"
      "--file"
      (builtins.toFile "run.kaem" ''
        set -ex
        M2LIBC_PATH=''${M2LIBC}
        alias CC="''${M2MESOPLANET_BIN} --architecture ''${ARCH} -f"
        CC ''${SRCDIR}/mkdir.c -o ./mkdir
        ./mkdir ''${out}
        ./mkdir ''${out}/bin
        BINDIR=''${out}/bin

        CC ''${SRCDIR}/sha256sum.c -o ''${BINDIR}/sha256sum
        CC ''${SRCDIR}/match.c -o ''${BINDIR}/match
        CC ''${SRCDIR}/mkdir.c -o ''${BINDIR}/mkdir
        CC ''${SRCDIR}/untar.c -o ''${BINDIR}/untar
        CC ''${SRCDIR}/ungz.c -o ''${BINDIR}/ungz
        CC ''${SRCDIR}/catm.c -o ''${BINDIR}/catm
        CC ''${SRCDIR}/cp.c -o ''${BINDIR}/cp
        CC ''${SRCDIR}/chmod.c -o ''${BINDIR}/chmod
        PATH=''${BINDIR}
        cp ''${M2MESOPLANET_BIN} ''${BINDIR}/M2-Mesoplanet
        chmod 0755 ''${BINDIR}/M2-Mesoplanet
        cp ''${BLOODELF} ''${BINDIR}/blood-elf
        chmod 0755 ''${BINDIR}/blood-elf
        cp ''${GETMACHINE} ''${BINDIR}/get_machine
        chmod 0755 ''${BINDIR}/get_machine
        cp ''${hex2} ''${BINDIR}/hex2
        chmod 0755 ''${BINDIR}/hex2
        cp ''${kaem} ''${BINDIR}/kaem
        chmod 0755 ''${BINDIR}/kaem
        cp ''${M1} ''${BINDIR}/M1
        chmod 0755 ''${BINDIR}/M1
        cp ''${M2PLANET_BIN} ''${BINDIR}/M2-Planet
        chmod 0755 ''${BINDIR}/M2-Planet
        cd ''${BINDIR}
        sha256sum -c ''${ANSWERS}
      '')
    ];
    inherit (full) M2MESOPLANET_BIN ARCH M2LIBC GETMACHINE BLOODELF M2PLANET_BIN;
    M2-Planet = full.M2PLANET_BIN;
    blood-elf = full.BLOODELF;
    M1 = stage0.M1;
    hex2 = stage0.hex2;
    kaem = stage0.kaem;
    SRCDIR = seed.mescc-tools-extra;
    ANSWERS = ./amd64.answers;
  };
in
extra
