#!/bin/sh

appname="$(basename "${0}" .sh).bin"

# Initialize binary path
bindir="$(dirname -- "$(readlink -f -- "${0}")")"
if [ "${bindir}" = "." ]; then
	bindir="${PWD}/${bindir}"
fi

# Initialize library path
libdir="$(readlink -f -- "$(dirname -- "${bindir}")/lib")"
export LD_LIBRARY_PATH="${libdir}"

# Initialize data path
datdir="$(readlink -f -- "$(dirname -- "${bindir}")/share/fritzing")"
if [ "${datdir}x" != "x" ]; then
	opts="${opts} -f \"${datdir}\""
fi

# Run application binary
eval exec "${bindir}/${appname}" "${opts}" "$@"
