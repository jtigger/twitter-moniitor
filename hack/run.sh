#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
# set -o xtrace

hack/download.sh
hack/extract.sh
