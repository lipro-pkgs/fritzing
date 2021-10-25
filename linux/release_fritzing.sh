#!/bin/bash

TOPDIR="$(readlink -f $(dirname ${0})/..)"
pushd "${TOPDIR}" >/dev/null

## ================================ PARSE ================================

if [ -z "${2}" ]; then
	echo "third parameter --release version-- is missing, should be:"
	echo "   something like '0.8.6b'"
	exit 1
fi

case ${1} in
2019)	QTDIR=/opt/Qt/5.15.2
	;;
2022)	QTDIR=/opt/Qt/6.4.0
	;;
*)	echo "second parameter --tool set version-- is missing, should be:"
	echo "    '2019', '2022'"
	exit 1
esac

if [ ! -d "${QTDIR}" ]; then
	echo "missing Qt SDK, execute Qt online installer"
	exit 1
fi

case $(uname -m) in
x86_64)	ODARCH="architecture: i386:x86-64"
	QTARCH="QMAKE_TARGET.arch=x86_64"
	AIMACH="amd64"
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

RD=release
BD=build
VD=Release

PN=fritzing
PV=${2}
PR=linux-${AIMACH}
RN=${PN}_${PV}_${PR}
echo "build ${PN}_${PV}_${PR}"
echo

## ============================== EVALUATE ===============================

export PATH=${TOPDIR}:${PATH}

LRELEASE="$(qtpaths --find-exe lrelease)"
[[ ! -x "${LRELEASE}" ]] && echo "Qt Linguist not found, check your Qt SDK."
[[ ! -x "${LRELEASE}" ]] && exit 1
echo "found Qt Linguist as ${LRELEASE}"
D=$(dirname $(dirname "${LRELEASE}"))
[[ "${D}" != "${QTDIR}" ]] && echo "Qt Linguist not from Qt SDK, check your PATH."
[[ "${D}" != "${QTDIR}" ]] && exit 1
echo

QMAKE="$(qtpaths --find-exe qmake)"
[[ ! -x "${QMAKE}" ]] && echo "Qt Make not found, check your Qt SDK."
[[ ! -x "${QMAKE}" ]] && exit 1
echo "found Qt Make as ${QMAKE}"
D=$(dirname $(dirname "${QMAKE}"))
[[ "${D}" != "${QTDIR}" ]] && echo "Qt Make not from Qt SDK, check your PATH."
[[ "${D}" != "${QTDIR}" ]] && exit 1
echo

GMAKE="$(qtpaths --find-exe make)"
[[ ! -x "${GMAKE}" ]] && echo "GNU Make not found, check your PATH."
[[ ! -x "${GMAKE}" ]] && exit 1
echo "found GNU Make as ${GMAKE}"
echo

OBJDUMP="$(qtpaths --find-exe objdump)"
[[ ! -x "${OBJDUMP}" ]] && echo "Object Dump not found, check your PATH."
[[ ! -x "${OBJDUMP}" ]] && exit 1
echo "found Object Dump as ${OBJDUMP}"
echo

WGET="$(qtpaths --find-exe wget)"
[[ ! -x "${WGET}" ]] && echo "WEB Getter not found, check your PATH."
[[ ! -x "${WGET}" ]] && exit 1
echo "found WEB Getter as ${WGET}"
echo

GIT="$(qtpaths --find-exe git)"
[[ ! -x "${GIT}" ]] && echo "Git not found, check your PATH."
[[ ! -x "${GIT}" ]] && exit 1
echo "found Git as ${GIT}"
echo

CLI7Z="$(qtpaths --find-exe 7z)"
[[ ! -x "${CLI7Z}" ]] && echo "7z not found, check your PATH."
[[ ! -x "${CLI7Z}" ]] && exit 1
echo "found 7z as ${CLI7Z}"
echo

QTLDT="$(qtpaths --find-exe linuxdeployqt)"
QTLDTURL="https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
if [[ ! -x "${QTLDT}" ]]; then
	"${WGET}" -q -nc -O "${TOPDIR}/linuxdeployqt" "${QTLDTURL}"
	chmod +x "${TOPDIR}/linuxdeployqt"
	QTLDT="$(qtpaths --find-exe linuxdeployqt)"
	[[ ! -x "${QTLDT}" ]] && echo "Linux Deployment Tool not found, check your workspace."
	[[ ! -x "${QTLDT}" ]] && exit 1
fi
echo "found Linux Deployment Tool as ${QTLDT}"
echo

BOOSTDIR="${TOPDIR}/boost"
[[ ! -d "${BOOSTDIR}" ]] && echo "Boost directory not found, check your workspace."
[[ ! -d "${BOOSTDIR}" ]] && exit 1

BOOSTCFG="${BOOSTDIR}/boost/config.hpp"
[[ ! -r "${BOOSTCFG}" ]] && echo "Boost header not found, check your workspace."
[[ ! -r "${BOOSTCFG}" ]] && exit 1

echo "found Boost in ${BOOSTDIR}"
echo "found   CFG as ${BOOSTCFG}"
echo

LIBGIT2="${TOPDIR}/libgit2/${BD}"
[[ ! -d "${LIBGIT2}" ]] && echo "Libgit2 build not found, check your workspace."
[[ ! -d "${LIBGIT2}" ]] && exit 1

LG2A="${LIBGIT2}/libgit2.a"
[[ ! -r "${LG2A}" ]] && echo "Libgit2 not found, check your workspace."
[[ ! -r "${LG2A}" ]] && exit 1

echo "found Libgit2 in ${LIBGIT2}"
echo "found       A as ${LG2A}"
echo

FZADIR="${TOPDIR}/fritzing-app"
[[ ! -d "${FZADIR}" ]] && echo "Fritzing App source not found, check your workspace."
[[ ! -d "${FZADIR}" ]] && exit 1

QMPRO="${FZADIR}/phoenix.pro"
[[ ! -r "${QMPRO}" ]] && echo "Qt Make project not found, check your workspace."
[[ ! -r "${QMPRO}" ]] && exit 1

echo "found Fritzing App in ${FZADIR}"
echo "found  Qt Make PRO as ${QMPRO}"
echo

FZPDIR="${TOPDIR}/fritzing-parts"
[[ ! -d "${FZPDIR}" ]] && echo "Fritzing Parts Library not found, check your workspace."
[[ ! -d "${FZPDIR}" ]] && exit 1

FZBCORE="${FZPDIR}/bins/core.fzb"
[[ ! -r "${FZBCORE}" ]] && echo "Fritzing Core Bin not found, check your workspace."
[[ ! -r "${FZBCORE}" ]] && exit 1

echo "found Fritzing Parts in ${FZPDIR}"
echo "found   Core Bin FZB as ${FZBCORE}"
echo

## ================================ BUILD ================================

## set environment variable for Qmake project (phoenix.pro) and/or pri files
QMDEF="boost_root=${BOOSTDIR}"

### NOT YET ### "${LRELEASE}" "${QMPRO}"
"${QMAKE}" -makefile -o Makefile "${QMPRO}" "${QMDEF}" "${QTARCH}" \
                                 DEFINES+=QUAZIP_LIB || exit 2
"${GMAKE}" --jobs=$(nproc --ignore=2) "${VD,,}" || exit 2

echo

## ============================== VALIDATE ===============================

# DESTDIR="${TOPDIR}/${RD}"
DESTDIR="${TOPDIR}"
[[ ! -d "${DESTDIR}" ]] && echo "Fritzing destination not found, check your build."
[[ ! -d "${DESTDIR}" ]] && exit 2

FZAEXE="${DESTDIR}/Fritzing"
[[ ! -x "${FZAEXE}" ]] && echo "Fritzing not found, check your build."
[[ ! -x "${FZAEXE}" ]] && exit 3

echo "found Fritzing in ${DESTDIR}"
echo "found      EXE as ${FZAEXE}"
echo -n "test       EXE is "
"${OBJDUMP}" -f "${FZAEXE}" | head -n 5 | grep "${ODARCH}" && rc=0 || rc=3
[[ ${rc} -eq 3 ]] && echo "Fritzing not for ${ODARCH}, check your build."
[[ ${rc} -eq 3 ]] && exit ${rc}
echo

## =============================== DEPLOY ================================

DEPLOY="${TOPDIR}/${RD}/deploy"
FORZIP="${TOPDIR}/${RD}/forzip"
RELEASE_BASE="${FORZIP}/${RN}"
RELEASE_ZIP="${RELEASE_BASE}.zip"

echo "Setting up deploy folder. Ignore any \"The system cannot find ...\" messages."
[[ -f "${RELEASE_ZIP}" ]] && rm -f "${RELEASE_ZIP}"
rm -rf "${FORZIP}"
rm -rf "${DEPLOY}"

mkdir -p "${FORZIP}"
mkdir -p "${DEPLOY}"
echo
echo "Deploy folder ready. ANY FURTHER \"The system cannot find ...\" MESSAGES"
echo "REPRESENT   SIGNIFICANT   PROBLEMS   WITH THE SCRIPT. (!)"
echo

echo "copy Fritzing application..."
"${QMAKE}" -install qinstall -exe \
           "${FZAEXE}" \
           "${DEPLOY}/$(basename ${FZAEXE})" || exit 3
"${QMAKE}" -install qinstall \
           "${FZADIR}/resources/images/fritzing_icon.png" \
           "${DEPLOY}/fritzing.png" || exit 3
"${QMAKE}" -install qinstall \
           "${FZADIR}/resources/system_icons/linux/fritzing.xml" \
           "${DEPLOY}/Fritzing.mime.xml" || exit 3
"${QMAKE}" -install qinstall \
           "${FZADIR}/org.fritzing.Fritzing.appdata.xml" \
           "${DEPLOY}/Fritzing.appdata.xml" || exit 3
"${QMAKE}" -install qinstall \
           "${FZADIR}/org.fritzing.Fritzing.desktop" \
           "${DEPLOY}/Fritzing.desktop" || exit 3
echo

echo "copy icons..."
for f in "${FZADIR}/resources/system_icons/linux"/fz*_icon*.png; do
	echo "    ${f}"
	"${QMAKE}" -install qinstall \
	           "${f}" \
	           "${DEPLOY}/pixmaps/$(basename ${f})" || exit 3
done
echo

echo "copy sketches, translations, help, README, LICENSE..."
for f in "${FZADIR}"/translations \
         "${FZADIR}"/sketches \
         "${FZADIR}"/help \
         "${FZADIR}"/*.1; do
	echo "    ${f}"
	"${QMAKE}" -install qinstall \
                   "${f}" \
                   "${DEPLOY}/${f#"${FZADIR}"}" || exit 3
done
for f in "${FZADIR}"/*.md \
         "${FZADIR}"/*.txt \
         "${FZADIR}"/LICENSE.*; do
	echo "    ${f}"
	"${QMAKE}" -install qinstall \
                   "${f}" \
                   "${DEPLOY}/doc/fritzing/${f#"${FZADIR}"}" || exit 3
done
echo

echo "removing empty translation files..."
find "${DEPLOY}/translations" -name "*.qm" -size -1024c -delete
find "${DEPLOY}/translations" -name "*.ts" -delete
echo

echo "copy Qt dependencies... (libraries, plugins, and translations)"
#"${QTLDT}" "${DEPLOY}/$(basename ${FZAEXE})" \
"${QTLDT}" "${DEPLOY}/Fritzing" \
           -qmake="${QMAKE}" \
           -unsupported-allow-new-glibc \
           -verbose=2 || exit 3
echo

echo "export Fritzing parts library..."
pushd "${DEPLOY}" >/dev/null
"${GIT}" clone --origin upstream --single-branch \
         "${FZPDIR}" parts || exit 3
"${GIT}" -C parts remote set-url upstream \
         "https://github.com/fritzing/fritzing-parts.git" || exit 3
popd >/dev/null
echo

## https://github.com/fritzing/fritzing-app/wiki/3.-Command-Line-Options
echo "run Fritzing to create parts database..."
"${DEPLOY}/Fritzing" -pp "${DEPLOY}/parts" \
                     -db "${DEPLOY}/parts/parts.db" || exit 4
echo

## ============================= PACKAGING ===============================

# [QnD] linuxdeployqt::skipGlibcCheck (-unsupported-allow-new-glibc)
"${QMAKE}" -install qinstall \
           "/usr/share/doc/libc6/copyright" \
           "${DEPLOY}/usr/share/doc/libc6/copyright" || exit 3
# [QnD] linuxdeployqt::skipGlibcCheck (-unsupported-allow-new-glibc)

echo "copy system library dependencies and create AppImage..."
#"${QTLDT}" "${DEPLOY}/$(basename ${FZAEXE})" \
VERSION="${PV}" "${QTLDT}" "${DEPLOY}/Fritzing.desktop" \
           -qmake="${QMAKE}" \
           -bundle-non-qt-libs \
           -unsupported-allow-new-glibc \
           -unsupported-bundle-everything \
           -appimage \
           -verbose=2 || exit 3
echo

# [QnD] linuxdeployqt::skipGlibcCheck (-unsupported-allow-new-glibc)
mv  -f "${DEPLOY}/usr/share/doc/libc6" "${DEPLOY}/doc/libc6"
rm -rf "${DEPLOY}/usr"
# [QnD] linuxdeployqt::skipGlibcCheck (-unsupported-allow-new-glibc)

echo "move deployments to ${RELEASE_BASE}"
mv -f "${DEPLOY}" "${RELEASE_BASE}"
echo

echo "move deployments to ${RELEASE_ZIP}"
"${CLI7Z}" a -y -r -tzip -sdel "${RELEASE_ZIP}" "${RELEASE_BASE}"
echo

echo "move deployments to ${TOPDIR}"
mv -f "${RELEASE_ZIP}" "${TOPDIR}"
echo

## ================================= EXIT ================================
popd >/dev/null
exit 0
