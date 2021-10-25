#!/bin/bash

pushd "$(readlink -f $(dirname ${0})/..)" >/dev/null

if pushd boost >/dev/null; then
	[[ -x ./bootstrap.sh ]] && ./bootstrap.sh
	[[ -x ./b2 ]] && ./b2 headers
	rc=${?}
	popd >/dev/null
fi

popd >/dev/null
exit ${rc}
