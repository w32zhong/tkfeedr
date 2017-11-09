#!/bin/sh
if [ "$1" == "-h" ]; then
cat << USAGE
Description:
Add feed link to tkfeedr.
Examples:
$0 http://teahour.fm/feed.xml [-f]
USAGE
exit
fi

[ $# -eq 0 ] && echo 'bad arg.' && exit

url="$1"
url_id=`echo "${url}" | grep -Po '(?<=//).+?(?=/)'`

force="$2"

echo "Searching domain key: ${url_id}"
grep "${url_id}" ~/tkfeedr/list/*.list
if [ $? -eq 0 -a "$force" != "-f" ]; then
	echo "exists."
else
	echo "not exists, adding..."
	echo "${url}" >> ~/tkfeedr/list/tmp.list
fi
