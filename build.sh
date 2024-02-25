#!/bin/bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd . &>/dev/null

cd ${DIR}
HASHCAT_DIR="${DIR}/hashcat/hashcat"
rm -rf ${HASHCAT_DIR}

DOWNDIR=`mktemp -d`

echo "DOWNDIR: ${DOWNDIR}"
cd ${DOWNDIR}

HASHCAT_ASSETS=`wget -O- -q https://github.com/hashcat/hashcat/releases/latest | grep -i include-fragment | grep assets | grep -Eo "src=\"(.+?)\"" | cut -d '"' -f 2`
#HASHCAT_URL=https://github.com/`wget -O- -q https://github.com/hashcat/hashcat/releases/latest | grep .7z | grep href | cut -f 2 -d '"'`
HASHCAT_URL=https://github.com/`wget -O- -q $HASHCAT_ASSETS | grep .7z | grep href | cut -f 2 -d '"'`

echo -n "Downloading ${HASHCAT_URL} ... "
wget -q -O hashcat.7z ${HASHCAT_URL}
7z x hashcat.7z &>/dev/null
rm hashcat.7z
mv * ${HASHCAT_DIR}

rm -rf ${DOWNDIR}
echo '[ OK ]'

VERSION=`date +%y.%m.%d`
echo -n "Setting version ... "
echo ${VERSION} > ${DIR}/version
echo [ ${VERSION} ]

echo -n "Creating sdist ... "
cd ${DIR}
#python ./setup.py sdist >/dev/null
python3 setup.py bdist_wheel --plat-name manylinux1_x86_64 --python-tag "py3"
python3 setup.py bdist_wheel --plat-name win_amd64 --python-tag "py3"

echo '[ OK ]'

popd &>/dev/null
