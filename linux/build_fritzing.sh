#!/bin/bash

pushd "$(readlink -f $(dirname ${0})/..)" >/dev/null

./linux/release_fritzing.sh 2019 ${1}
rc=${?}

popd >/dev/null
exit ${rc}
