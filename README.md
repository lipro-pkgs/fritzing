Fritzing (Packaging)
====================

The Fritzing application is an Electronic Design Automation software with
a low entry barrier, suited for the needs of makers and hobbyists. It
offers a unique real-life "breadboard" view, and a parts library with
many commonly used high-level components. Fritzing makes it very easy
to communicate about circuits, as well as to turn them into PCB layouts
ready for production.

# Project Structure

* *fritzing-app*: **[0.9.9-20210922](https://github.com/fritzing/fritzing-app/commits/main)**
* *fritzing-parts*: **[0.9.9-20210916](https://github.com/fritzing/fritzing-parts/commits/main)**
* *libgit2*: **[v1.30](https://github.com/libgit2/libgit2/releases/tag/v1.3.0)**
* *boost*: **[v1.77.0](https://www.boost.org/users/history/version_1_77_0.html)**

## Fritzing Application

The Fritzing application as described above.

*Primary-site*: https://fritzing.org/

*Primary-repo*: https://github.com/fritzing/fritzing-app

**Git submodule import:**

```
git submodule add --name fritzing-app --branch main -- \
    https://github.com/fritzing/fritzing-app.git fritzing-app
git submodule update --init --recursive --single-branch -- fritzing-app
git commit -sm 'New upstream module: fritzing-app 0.9.9-20210922' \
           -m "git-describe: $(git -C fritzing-app describe --tags)"
```

## Fritzing Parts Library

Fritzing is installed with a Parts Library. Parts are organized into *bins*
which can be accessed from the parts palette on the right. Fritzing ships
with several bins, for example *Core* and *Mine*.

*Primary-site*: https://fritzing.org/parts

*Primary-repo*: https://github.com/fritzing/fritzing-parts

Fritzing will use this Git repository as its default offline parts library.

**Git submodule import:**

```
git submodule add --name fritzing-parts --branch main -- \
    https://github.com/fritzing/fritzing-parts.git fritzing-parts
git submodule update --init --recursive --single-branch -- fritzing-parts
git commit -sm 'New upstream module: fritzing-parts 0.9.9-20210916' \
           -m "git-describe: $(git -C fritzing-parts describe --tags)"
```

## Libgit2

Libgit2 is a dependency-free, portable, pure C implementation of Git,
with a focus on having a nice API for use within other programs.

*Primary-site*: https://libgit2.org/

*Primary-repo*: https://github.com/libgit2/libgit2

Fritzing will use this API to have access to external parts libraries hosted
online in an Git trepository and reachable over HTTPS. Libgit2 must be compiled
in front, either statically as suggest in Fritzing original build description
or as in the case of this project dynamically to avoid some unexpected link
errors that were discussued again and again.

**Git submodule import:**

```
git submodule add --name libgit2 --branch main -- \
    https://github.com/libgit2/libgit2.git libgit2
git submodule update --init --recursive --single-branch -- libgit2
git -C libgit2 checkout v1.3.0
git -C libgit2 submodule update --init --recursive --single-branch
git add libgit2
git commit -sm 'New upstream module: libgit2 v1.3.0'
```

## Boost C++ Libraries

Boost provides free peer-reviewed portable C++ source libraries.

*Primary-site*: https://www.boost.org/

*Primary-repo*: https://github.com/boostorg/boost

It should be sufficient to use a recent version (boost 1.70 or later).
Using boost 1.54 will lead to application crashes later on. Note that
Fritzing currently only uses boost headers, so you don't need to compile
the boost libraries.

**Git submodule import:**

```
git submodule add --name boost --branch master -- \
    https://github.com/boostorg/boost.git boost
git submodule update --init --recursive --single-branch -- boost
git -C boost checkout boost-1.77.0
git -C boost submodule update --init --recursive --single-branch
git add boost
git commit -sm 'New upstream module: boost v1.77.0'
```

# Compilation

The Fritzing source code is written in C++ using the Qt-framework. The source
code is portable and compilable on Linux, Mac OS X, and Windows 10.

## Prerequisites

### Linux

On Ubuntu/Debian you need the following:

```
sudo apt-get install build-essential git cmake qt5-default \
                     libqt5svg5-dev libqt5serialport5-dev \
                     libssl-dev libudev-dev libgit2-dev \
                     libboost-dev
```

#### CMake

On Ubuntu/Debian you need the following:

```
sudo apt-get install cmake
```

### Mac OS X

Download and install [Xcode](https://developer.apple.com/xcode/),
if you don't have it.

#### CMake

Use [Homebrew ](https://brew.sh/) to install *cmake*:

```
brew install cmake
```

... or download and install the precompiled binaries from the
[official website](https://cmake.org/download/) --> Latest Release (3.21.3).

### Windows 10

Download and install [Microsoft Visual Studio](https://www.visualstudio.com/),
if you don't have it.

[Community 2019](https://visualstudio.microsoft.com/de/thank-you-downloading-visual-studio/?sku=Community&rel=16)
is god enough.

#### CMake

Download and install the precompiled binaries from the
[official website](https://cmake.org/download/) --> Latest Release (3.21.3).

### Qt widget library

In order to build Fritzing you are going to need the latest version of Qt
Creator. You can [download it for free](http://www.qt.io/download-open-source/)
using the [online installer](https://www.qt.io/download-qt-installer). Download
and install the Qt open source edition, alway try to use the latest version of
Qt. The current Qt version required is **5.15.2**. Earlier versions might still
compile but we are adapting to Qt deprecation messages.

The online installer is the easiest route to go. In the installer, you need to
pick the right version and the compiler for your platform:

* **Linux:** select *5.15.2* (or higher) --> *gcc*
* **Mac OS X:** select *5.15.2* (or higher) --> *clang 64bit*
* **Windows 10**: Choose *msvcXX* in the respective version of Microsoft Visual
  Studio including Visual C++ support, ex. *msvc16* for *Community 2019*.
  Fritzing recommend *msvcXX* for compatibility reasons, even though it takes
  up several gigabytes on your drive. For MinGW, select *5.15.2* (or higher)
  --> *MinGW*. If you choose *MinGW*, also select it under Tools.

# Build release package

## Linux

**COMING SOON**

## Mac OS X

**COMING SOON**

## Windows 10

**COMING SOON**

# References

* [Building Fritzing](https://github.com/fritzing/fritzing-app/wiki/1.-Building-Fritzing)
  * [Mac notes](https://github.com/fritzing/fritzing-app/wiki/1.1-Mac-notes)
  * [Windows notes](https://github.com/fritzing/fritzing-app/wiki/1.2-Windows-notes)
  * [Linux notes](https://github.com/fritzing/fritzing-app/wiki/1.3-Linux-notes)
  * [Building Qt from Source](https://github.com/fritzing/fritzing-app/wiki/1.4-Building-Qt-from-Source)
* [Fritzing is still free! (how to build from source)](https://siytek.com/build-fritzing)

---

This is an unofficial fork!
===========================

Original written and maintained by the Friends-of-Fritzing e.V., a
non-profit foundation based in Berlin, Germany. The project has grown
out of a state-funded research project at the
[Interaction Design Lab](http://idl.fh-potsdam.de/) at
[Potsdam University of Applied Sciences](http://fh-potsdam.de/).


*Primary-site*: http://fritzing.org/

*Primary-repos*:

   * https://github.com/fritzing/fritzing-app
   * https://github.com/fritzing/fritzing-parts

**At least, you have to read the origin author's hints at
https://fritzing.org/faq/ and espacialy the license notices.**
