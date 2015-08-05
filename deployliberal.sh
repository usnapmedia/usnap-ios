#!/bin/sh

set -e

BASEDIR=$(dirname $0)
TARGET=$BASEDIR/../usnap_build/build
GEMFILE=$BASEDIR/Gemfile

agvtool next-version -all
ipa build -w uSnap.xcworkspace -s Liberal -c Liberal --archive -d $TARGET --verbose
#ipa distribute:itunesconnect -a ciprian.rarau@usnap.com -p 3O6b#PJuBQfkbXgd -i 997099578 --upload --verbose