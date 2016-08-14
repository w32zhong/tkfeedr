#!/bin/sh
if [ "$1" == "-h" ]; then
cat << USAGE
Description:
Add feed link to tkfeedr.
Examples:
$0 http://teahour.fm/feed.xml
USAGE
exit
fi

[ $# -ne 1 ] && echo 'bad arg.' && exit

url="$1"
url_id=`echo "${url}" | grep -Po '(?<=//).+?(?=/)'`

echo "Searching domain key: ${url_id}"
grep "${url_id}" /home/tk/tksync/proj/tkfeedr/list/*.list
if [ $? -eq 0 ]; then
	echo "exists."
else
	echo "not exists, adding..."
	echo "${url}" >> /home/tk/tksync/proj/tkfeedr/list/tmp.list
fi
