Prerequisites for compilation
=============================

The Fritzing source code is written in C++ using the Qt-framework. The source
code is portable and compilable on Linux, Mac OS X, and Windows 10. You need
the tools described below to compile on the supported target systems. 

---

## Linux

On Ubuntu/Debian you need the following:

```
sudo apt-get install wget git p7zip-full build-essential libssl-dev
```

### CMake

On Ubuntu/Debian you need the following:

```
sudo apt-get install cmake
```

---

## Mac OS X

Download and install [Xcode](https://developer.apple.com/xcode/),
if you don't have it.

### CMake

Use [Homebrew ](https://brew.sh/) to install *cmake*:

```
brew install cmake
```

... or download and install the precompiled binaries from the
[official website](https://cmake.org/download/) --> Latest Release (3.21.3).

---

## Windows 10

Download and install [Microsoft Visual Studio](https://www.visualstudio.com/),
if you don't have it.

[Community 2019](https://visualstudio.microsoft.com/de/thank-you-downloading-visual-studio/?sku=Community&rel=16)
is god enough.

### CMake

Download and install the precompiled binaries from the
[official website](https://cmake.org/download/) --> Latest Release (3.21.3).

---

## Qt widget library

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