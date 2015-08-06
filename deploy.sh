#!/bin/sh

set -e

BASEDIR=$(dirname $0)
TARGET=$BASEDIR/../usnap_build/build
GEMFILE=$BASEDIR/Gemfile

APP=uSnap

agvtool next-version -all
ipa build -w uSnap.xcworkspace -s uSnap -c $APP --archive -d $TARGET --verbose
ipa distribute:itunesconnect -f $TARGET/$APP.ipa  -a ciprian.rarau@usnap.com -p 3O6b#PJuBQfkbXgd -i 997099578 --upload --verbose -file /Users/cip/usnap/usnap_build/build/uSnap.ipa