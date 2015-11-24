#!/bin/bash -e
# build.sh - Build Satellite 6 packages
#
#   This script should be run from the root of the package's git repo
#
# Requirements:
# - tito
# - koji
# - brewkoji
# - mock
#
DIST='.el7'
OUTPUTDIR='tito_build'

mkdir -p "$OUTPUTDIR"
SRC_RPM="$(
    tito build \
        --offline \
        --srpm \
        --test \
        --dist="${DIST}" \
        --scl=ruby193 \
        --output="$OUTPUTDIR" \
    | sed -nre 's/^Wrote: (.*\.src\.rpm)$/\1/p'
)"

echo Tito built: "$SRC_RPM"

PYLIBSPATH="$(dirname "$0")/../lib/python"
python "$PYLIBSPATH/mock_brew.py" "$SRC_RPM"
