#!/bin/bash

cat <<EOF > configure/RELEASE.local
EPICS_BASE=${EPICS_BASE}
EOF

if [[ "$target_platform" == "osx-arm64" ]]; then
  export EPICS_HOST_ARCH="darwin-aarch64"
elif [[ "$target_platform" == "osx-64" ]]; then
  export EPICS_HOST_ARCH="darwin-x86"
else
  export EPICS_HOST_ARCH=$(perl ${EPICS_BASE}/lib/perl/EpicsHostArch.pl)
fi

make -j ${CPU_COUNT}

install -d ${PREFIX}/bin/
mv ${SRC_DIR}/python*/${EPICS_HOST_ARCH}/p4p ${SP_DIR}/
mv ${SRC_DIR}/bin/${EPICS_HOST_ARCH}/pvagw ${PREFIX}/bin
