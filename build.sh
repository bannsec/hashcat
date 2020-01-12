DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd . &>/dev/null

cd $DIR
HASHCAT_DIR="$DIR/hashcat/hashcat"
HASHCAT_VER=`cat version | cut -d '-' -f 1`
HASHCAT_URL="https://hashcat.net/files/hashcat-${HASHCAT_VER}.7z"

rm -rf $HASHCAT_DIR

DOWNDIR=`mktemp -d`

cd $DOWNDIR
echo -n "Downloading $HASHCAT_URL ... "
wget -q -O hashcat.7z https://hashcat.net/files/hashcat-5.1.0.7z
7z x hashcat.7z &>/dev/null
rm hashcat.7z
mv * $HASHCAT_DIR

rm -rf $DOWNDIR
echo '[ OK ]'

echo -n "Creating sdist ... "
cd $DIR
python ./setup.py sdist >/dev/null

echo '[ OK ]'

popd &>/dev/null

