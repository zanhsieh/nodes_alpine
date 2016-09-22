#!/usr/bin/env bash

EMAIL="zanhsieh@gmail.com"
TARGET_DIR="/tmp/nodejs"
TMP_DIR="/tmp/packages"

if [ ! -d "/vagrant/.abuild" ]; then
  docker run \
    --name keys \
    --entrypoint abuild-keygen \
    -e PACKAGER="$EMAIL" \
    andyshinn/alpine-abuild:edge -n &> /tmp/mylog

  ID=$(cat /tmp/mylog | grep rsa.pub | cut -d "-" -f2 | cut -d "." -f1)

  MY_KEY_ID="$EMAIL-$ID"

  mkdir -p /vagrant/.abuild
  docker cp keys:/home/builder/.abuild/$MY_KEY_ID.rsa /vagrant/.abuild/
  docker cp keys:/home/builder/.abuild/$MY_KEY_ID.rsa.pub /vagrant/.abuild/
  docker rm -f keys
else
  ID=$(ls -a /vagrant/.abuild | grep zanhsieh@gmail.com | grep rsa.pub | cut -d "-" -f2 | cut -d "." -f1)
  MY_KEY_ID="$EMAIL-$ID"
fi
# echo $MY_KEY_ID
sudo cp -R /vagrant/.abuild ~/

mkdir -p $TMP_DIR/builder/x86_64
mkdir -p $TARGET_DIR
sudo chown vagrant:vagrant -R $TMP_DIR
sudo chown vagrant:vagrant -R $TARGET_DIR

[ ! -f $TARGET_DIR/APKBUILD ] &&  wget -P $TARGET_DIR http://git.alpinelinux.org/cgit/aports/plain/main/nodejs/APKBUILD

cd $TARGET_DIR
docker run \
    -e RSA_PRIVATE_KEY="`cat ~/.abuild/$MY_KEY_ID.rsa`" \
    -e RSA_PRIVATE_KEY_NAME="$MY_KEY_ID.rsa" \
    -v "$TARGET_DIR:/home/builder/package" \
    -v "$TMP_DIR:/packages" \
    -v "$HOME/.abuild/$MY_KEY_ID.rsa.pub:/etc/apk/keys/$MY_KEY_ID.rsa.pub" \
    andyshinn/alpine-abuild:edge
cd -

cp -R $TMP_DIR/builder /vagrant/
