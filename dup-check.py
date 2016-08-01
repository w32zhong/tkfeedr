from urllib.parse import urlparse
import glob
import sys
import os

cur_dir = os.path.dirname(os.path.realpath(__file__))
feed_list_path = cur_dir + "/list/*.list"
feed_lists = glob.glob(feed_list_path)
lookup = dict()

for li_name in feed_lists:
	f = open(li_name, 'r')
	lines = f.readlines()
	for line in lines:
		line = line.rstrip()
		host = urlparse(line).hostname
		path = urlparse(line).path
		key = host + path
		if key in lookup:
			lookup[key] = lookup[key] + 1
		else:
			lookup[key] = 1

dup_li = list()
for key in lookup:
	if lookup[key] > 1:
		dup_li.append((key, lookup[key]))

dup_li.sort(key=lambda x: x[1])

print("duplicate feed URLs:")
print(dup_li)

find = "find " + os.path.dirname(feed_list_path) + \
       " -type f -name '*.list' | xargs grep --color "

for t in dup_li:
	os.system(find + t[0])
