{
  bootstrap-seeds = builtins.fetchTarball {
    url = "https://github.com/oriansj/bootstrap-seeds/archive/b09a8b8cbcb6d3fdb025f1bf827d98a8cb3b4d41.tar.gz";
    sha256 = "sha256:1l7fwmppsizgqyp1yfsfv03vjqnzwfhpngxdp70zbsww5lggmspw";
  };
  stage0-posix-amd64 = builtins.fetchTarball {
    url = "https://github.com/oriansj/stage0-posix-amd64/archive/8ec9336cfe14406caed6c0d4bdb287c876ecfe76.tar.gz";
    sha256 = "sha256:0v1j35nf7v4kfni6z08pgh2cs6c2adgx9v9f5wx3mm044i6wywk5";
  };
  M2-Planet = builtins.fetchTarball {
    url = "https://github.com/oriansj/M2-Planet/archive/c9b99209863ae2ce91e0eb1c87d2adb7626b74e9.tar.gz";
    sha256 = "sha256:1jdds87fr9jch6m3d62ar9vji25yc3njwfz08d05s2ldv7sc9sc3";
  };
  M2libc = builtins.fetchTarball {
    url = "https://github.com/oriansj/M2libc/archive/b774c03f339675c44871c7ef2a6058a083341e6d.tar.gz";
    sha256 = "sha256:0kmscxga8mhw03dqcmc8zzpsfw10qshqzzw9ajx807fz52vrdp7h";
  };
  mescc-tools = builtins.fetchTarball {
    url = "https://github.com/oriansj/mescc-tools/archive/8a8d91cc526431f8199f5c2f1649f7fe09ba63d6.tar.gz";
    sha256 = "sha256:09kmiz2h7cys663a788pw5x3a6djjrcspqjyhinn7gqn7a7lhi6m";
  };
  M2-Mesoplanet = builtins.fetchTarball {
    url = "https://github.com/NickCao/M2-Mesoplanet/archive/71078487ea6af7021ba14981b8271f90bcf85422.tar.gz";
    sha256 = "sha256:13942qxfzydg2zv5n5nzqzz6sjjshwgp522ryf4sl9ybfk9q1vcm";
  };
  mescc-tools-extra = builtins.fetchTarball {
    url = "https://github.com/oriansj/mescc-tools-extra/archive/adc619ef8f596e3b9c40782540ec8678c6243d0d.tar.gz";
    sha256 = "sha256:1c8z647rin5cklik8vvibvsz9vr86552d17jlhc9vasywwgb7mli";
  };
  mes = builtins.fetchurl {
    url = "https://ftp.gnu.org/gnu/mes/mes-0.24.tar.gz";
    sha256 = "sha256:00lrpm4x5qg0l840zhbf9mr67mqhp8gljcl24j5dy0y109gf32w2";
  };
}
