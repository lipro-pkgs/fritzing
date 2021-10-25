Build release package
=====================

The Fritzing source code is written in C++ using the Qt-framework. The source
code is portable and compilable on Linux, Mac OS X, and Windows 10. 

Before you can build a release, this packaging project must be cloned. Thereby
all necessary [Git submodules](SUBMODULES.md) will be synchronized too:

```
git clone --recurse-submodules git@github.com:lipro-pkgs/fritzing-overall.git
cd fritzing-overall
```

---

## Linux

All build steps are done on command line.

### Bootstrap Boost C++ Header

```
./linux/bootstrap_boost.sh
```

### Build Libgit2 and Fritzing

Only **64 bit (x86-64)** builds will be supported:

```
./linux/build_libgit2.sh
./linux/build_fritzing.sh 0.9.9+LPN2021Q4-1
```

---

## Mac OS X

**COMING SOON**

---

## Windows 10

All build steps are done on command line. To do this, open a Windows command
prompt with `⊞ Win`+`R`, enter `cmd` and press `↵ Enter`. Then change to the
directory where the README.md file lives, the top folder of this project.

### Bootstrap Boost C++ Header

```
windows\bootstrap_boost.bat
```

### Build Libgit2 and Fritzing

**32 bit (x86)**:

```
windows\build_libgit2_x86.bat
windows\build_fritzing_x86.bat 0.9.9+LPN2021Q4-1
```

**64 bit (x86-64)**:

```
windows\build_libgit2_x86-64.bat
windows\build_fritzing_x86-64.bat 0.9.9+LPN2021Q4-1
```
