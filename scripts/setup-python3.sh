#!/bin/bash

set -Cue

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
PROJECT_DIR=$(realpath """${SCRIPT_DIR}/../""")

LOCAL_DIR="${PROJECT_DIR}/local"
BUILD_SRC_DIR="${LOCAL_DIR}/src"
BUILD_BIN_DIR="${LOCAL_DIR}/bin"

PYTHON3_VERSION="3.10.4"

cd "${SCRIPT_DIR}"

function install-dependences() {

    cat <<EOF2 | sudo su -

    if [ -f /etc/apt/sources.list.d/setup-sparqlwrapper.list ]; then
       rm /etc/apt/sources.list.d/setup-sparqlwrapper.list
    fi

    cat <<EOF | tee -a /etc/apt/sources.list.d/setup-sparqlwrapper.list
# This file was created by "setup-sparqlwrapper".
# It enables a complete build of python3.
# You can delete this file if you don't need it.

# https://devguide.python.org/setup/#install-dependencies
# https://github.com/inutomo0123/setup-sparqlwrapper

EOF

egrep "^deb" /etc/apt/sources.list \
    | sed "s/^deb/&-src/" \
    | tee -a /etc/apt/sources.list.d/setup-sparqlwrapper.list


apt-get update

apt-get install -y \
	build-essential gdb lcov pkg-config \
	libbz2-dev libffi-dev libgdbm-dev \
	libgdbm-compat-dev liblzma-dev \
	libncurses5-dev libreadline6-dev \
	libsqlite3-dev libssl-dev \
	lzma lzma-dev tk-dev uuid-dev zlib1g-dev

EOF2
}


function download-python3() {

    mkdir -p "${BUILD_SRC_DIR}"
    cd "${BUILD_SRC_DIR}"

    wget "https://www.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz"

    tar zxvf "Python-${PYTHON3_VERSION}.tgz"
}


function build-python3() {

    cd "${BUILD_SRC_DIR}/Python-${PYTHON3_VERSION}"

    ./configure --with-pydebug --prefix="${LOCAL_DIR}" 
		
    make && make install
}

function generate-activate-script() {

    cat <<EOF >|"${BUILD_BIN_DIR}/activate-python3"
# This file was created by "setup-sparqlwrapper".
# Add the PAHT to the installed python3 at the beginning of \$PATH.

# \$ source ./local/bin/activate-python3

# https://github.com/inutomo0123/setup-sparqlwrapper

PATH="${BUILD_BIN_DIR}:\${PATH}"

echo "Activated! python3: \$(which python3)"
    
EOF

}


install-dependences
download-python3
build-python3
generate-activate-script
