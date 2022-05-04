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
    url = "https://github.com/oriansj/mes-m2/archive/dad1744fa80f52b3b428803c06b09d39c285f500.tar.gz";
    sha256 = "sha256:155hnqaw44ddz2q0bphjqyaq29a8b75ahwd50zv1zakarp8i9nm8";
  };
  nyacc = builtins.fetchTarball {
    url = "https://download.savannah.gnu.org/releases/nyacc/nyacc-1.00.2.tar.gz";
    sha256 = "sha256:06rg6pn4k8smyydwls1abc9h702cri3z65ac9gvc4rxxklpynslk";
  };
  gash = builtins.fetchTarball {
    url = "http://download.savannah.nongnu.org/releases/gash/gash-0.3.0.tar.gz";
    sha256 = "sha256:1zfpvv46ykys1wi71w9w7a3lv95cq1ivanrlqx9lyfmj7nr3dabf";
  };
}
