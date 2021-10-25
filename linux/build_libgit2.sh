#!/bin/bash

pushd "$(readlink -f $(dirname ${0})/..)" >/dev/null

./linux/release_libgit2.sh 2019
rc=${?}

popd >/dev/null
exit ${rc}
