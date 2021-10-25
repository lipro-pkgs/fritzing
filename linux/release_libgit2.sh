#!/bin/bash

TOPDIR="$(readlink -f $(dirname ${0})/..)"
pushd "${TOPDIR}" >/dev/null

## ==============================   PARSE   ==============================

case ${1} in
2019)	CMPLAT=Ninja
	QTDIR=/opt/Qt/5.15.2
	;;
2022)	CMPLAT=Ninja
	QTDIR=/opt/Qt/6.4.0
	;;
*)	echo "second parameter --tool set version-- is missing, should be:"
	echo "    '2019', '2022'"
	exit 1
esac

if [ ! -d "${QTDIR}" ]; then
	echo "missing Qt SDK, execute Qt online installer"
	exit 1
fi

if [ ! -x "$(dirname ${QTDIR})/Tools/Ninja/ninja" ]; then
	echo "missing Ninja in Qt SDK, execute Qt online installer"
	exit 1
fi

if [ ! -x "$(dirname ${QTDIR})/Tools/CMake/bin/cmake" ]; then
	echo "missing CMake in Qt SDK, execute Qt online installer"
	exit 1
fi

export PATH=$(dirname ${QTDIR})/Tools/Ninja:${PATH}
export PATH=$(dirname ${QTDIR})/Tools/CMake/bin:${PATH}
echo "using CMake(${CMPLAT}) for ${1}"

case $(uname -m) in
x86_64)	ODARCH="architecture: i386:x86-64"
	export QTDIR=${QTDIR}/gcc_64
	;;
*)	echo "unsupported --target architecture--"
	exit 1
esac

if [ ! -d "${QTDIR}" ]; then
	echo "missing Qt SDK, use execute Qt online installer"
	exit 1
fi

export PATH=${QTDIR}/bin:${PATH}
echo "using Qt $(qtpaths --qt-version) for ${ODARCH}"
echo

BD=build
VD=Release

## ============================== EVALUATE ===============================

export PATH=${TOPDIR}:${PATH}

CMAKE="$(qtpaths --find-exe cmake)"
[[ ! -x "${CMAKE}" ]] && echo "CMake not found, check your Qt SDK."
[[ ! -x "${CMAKE}" ]] && exit 1
echo "found CMake as ${CMAKE}"
echo

NINJA="$(qtpaths --find-exe ninja)"
[[ ! -x "${NINJA}" ]] && echo "Ninja not found, check your Qt SDK."
[[ ! -x "${NINJA}" ]] && exit 1
echo "found Ninja as ${NINJA}"
echo

OBJDUMP="$(qtpaths --find-exe objdump)"
[[ ! -x "${OBJDUMP}" ]] && echo "Object Dump not found, check your PATH."
[[ ! -x "${OBJDUMP}" ]] && exit 1
echo "found Object Dump as ${OBJDUMP}"
echo

LIBGIT2_SRC="${TOPDIR}/libgit2"
[[ ! -d "${LIBGIT2_SRC}" ]] && echo "Libgit2 source not found, check your workspace."
[[ ! -d "${LIBGIT2_SRC}" ]] && exit 1

LIBGIT2_BLD="${LIBGIT2_SRC}/${BD}"
[[ -d "${LIBGIT2_BLD}" ]] && echo "Libgit2 build exist, clean by remove."
[[ -d "${LIBGIT2_BLD}" ]] && rm -rf "${LIBGIT2_BLD}"

echo "found Libgit2 in ${LIBGIT2_SRC}"
echo "build Libgit2 in ${LIBGIT2_BLD}"
echo

## ==============================   BUILD   ==============================

"${CMAKE}" -S "${LIBGIT2_SRC}" -B "${LIBGIT2_BLD}" -G "${CMPLAT}" \
           -DUSE_SSH=OFF \
           -DUSE_GSSAPI=OFF \
           -DUSE_SHA1=OpenSSL \
           -DUSE_HTTPS=OpenSSL \
           -DUSE_NTLMCLIENT=ON \
           -DUSE_BUNDLED_ZLIB=bundled \
           -DUSE_HTTP_PARSER=bundled \
           -DREGEX_BACKEND=builtin \
           -DBUILD_SHARED_LIBS=OFF \
           -DBUILD_CLAR=OFF \
    || exit 2
"${CMAKE}" --build "${LIBGIT2_BLD}" --config "${VD}" || exit 2
#"${CMAKE}" --install "${LIBGIT2_BLD}" --config "${VD}" \
#           --strip --prefix /tmp/AppDir || exit 2

echo

## ============================== VALIDATE ===============================

LG2A="${LIBGIT2_BLD}/libgit2.a"
[[ ! -r "${LG2A}" ]] && echo "Libgit2 not found, check your build."
[[ ! -r "${LG2A}" ]] && exit 3

echo "found Libgit2 in ${LIBGIT2_BLD}"
echo "found       A as ${LG2A}"
echo -n "test        A is "
"${OBJDUMP}" -f "${LG2A}" | head -n 5 | grep "${ODARCH}" && rc=0 || rc=3
[[ ${rc} -eq 3 ]] && echo "Libgit2 not for ${ODARCH}, check your build."
[[ ${rc} -eq 3 ]] && exit ${rc}
echo

## ================================= EXIT ================================
popd >/dev/null
exit 0
