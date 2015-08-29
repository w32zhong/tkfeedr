#!/bin/sh
cat import.opml | grep -P -o '(?<=xmlUrl\=").+(?=")' | tee feed-imported.list
