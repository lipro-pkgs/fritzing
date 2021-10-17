Fritzing (Packaging)
====================

The Fritzing application is an Electronic Design Automation software with
a low entry barrier, suited for the needs of makers and hobbyists. It
offers a unique real-life "breadboard" view, and a parts library with
many commonly used high-level components. Fritzing makes it very easy
to communicate about circuits, as well as to turn them into PCB layouts
ready for production.

# Project Structure

* *boost*: **[v1.77.0](https://www.boost.org/users/history/version_1_77_0.html)**

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
