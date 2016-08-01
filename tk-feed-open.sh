#!/bin/sh
url=`cat "$1" | head -1`
xdg-open "${url}"
