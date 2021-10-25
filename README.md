Fritzing (Packaging)
====================

The Fritzing application is an Electronic Design Automation software with
a low entry barrier, suited for the needs of makers and hobbyists. It
offers a unique real-life "breadboard" view, and a parts library with
many commonly used high-level components. Fritzing makes it very easy
to communicate about circuits, as well as to turn them into PCB layouts
ready for production.

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

---

Content
=======

## Project Structure

* *fritzing-app*: **[0.9.9-20210922](https://github.com/fritzing/fritzing-app/commits/main)**
* *fritzing-parts*: **[0.9.9-20210916](https://github.com/fritzing/fritzing-parts/commits/main)**
* *libgit2*: **[v1.30](https://github.com/libgit2/libgit2/releases/tag/v1.3.0)**
* *boost*: **[v1.77.0](https://www.boost.org/users/history/version_1_77_0.html)**

## Further documentation

* [Git submodules for packaging](doc/SUBMODULES.md)
* [Prerequisites for compilation](doc/PREREQUISITES.md)
* [Build release package](doc/BUILD-RELEASE.md)

## References

* [Building Fritzing](https://github.com/fritzing/fritzing-app/wiki/1.-Building-Fritzing)
  * [Mac notes](https://github.com/fritzing/fritzing-app/wiki/1.1-Mac-notes)
  * [Windows notes](https://github.com/fritzing/fritzing-app/wiki/1.2-Windows-notes)
  * [Linux notes](https://github.com/fritzing/fritzing-app/wiki/1.3-Linux-notes)
  * [Building Qt from Source](https://github.com/fritzing/fritzing-app/wiki/1.4-Building-Qt-from-Source)
* [Fritzing is still free! (how to build from source)](https://siytek.com/build-fritzing)
* [Qt Deploying](https://wiki.qt.io/Deploying)
  * [CQtDeployer - Universal Deployment Utility](https://wiki.qt.io/CQtDeployer)
    * [CQtDeployer GitHub Project](https://github.com/QuasarApp/CQtDeployer)
  * [Deploying a Qt5 Application Linux](https://wiki.qt.io/Deploying_a_Qt5_Application_Linux)
    * `linuxdeployqt`: [LinuxDeployQt GitHub Project](https://github.com/probonopd/linuxdeployqt)
  * [Deploy an Application on Windows](https://wiki.qt.io/Deploy_an_Application_on_Windows)
    * `windeployqt`: [Qt for Windows - Deployment](https://doc.qt.io/Qt-5/windows-deployment.html)
  * [Deploying Qt Applications on macOS](https://doc.qt.io/qt-5/macos.html#deploying-applications-on-macos)
    * `macdeployqt`: [Qt for macOS - Deployment](https://doc.qt.io/qt-5/macos-deployment.html)
