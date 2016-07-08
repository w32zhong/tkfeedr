#!/usr/bin/python3
import feedparser
import hashlib 
import os 
import sys
import datetime 
import glob
import socket
import time 

ret_updated = "updated"
ret_no_update = "no_update"
ret_bad = "bad_feed_or_connection"
cur_dir = os.path.dirname(os.path.realpath(__file__))
home = os.environ['HOME']

def ctime():
	return datetime.datetime.utcnow()

def quick_save(path, fname, content):
	fpath_utf8 = path + '/' + fname[0:64]
	fpath_utf8 = fpath_utf8 + '.tkfd'
	fpath_utf8 = fpath_utf8.encode('utf-8')
	path_utf8 = path.encode('utf-8') 
	if not os.path.exists(path_utf8):
		os.makedirs(path_utf8)
	f = open(fpath_utf8, 'w')
	f.write(content)
	f.close()

def valid_fname(name):
	mapping = [(' ', '_'), ('/', '_'), ('.', '_'),
	           ('\\', '_'), ('"', '_'), ('\'', '_')]
	for k, v in mapping:
		name = name.replace(k, v)
	return name

def save_feed(feed):
	fe_title = ''
	if hasattr(feed['feed'], 'title'):
		fe_title = valid_fname(feed['feed']['title'])
	elif hasattr(feed['feed'], 'link'):
		fe_title = valid_fname(feed['feed']['link'])
	else:
		fe_title = str(ctime())
	fe_link = 'no link :0'
	if hasattr(feed['feed'], 'link'):
		fe_link = feed['feed']['link']
	path = home + '/feeds/' + fe_title
	print("saving `%s'..." % fe_link)
	quick_save(path, '0 url', fe_link)
	i = 1
	for ent in feed.entries:
		ent_title = ''
		if hasattr(ent, 'title'):
			ent_title = valid_fname(ent.title)
		elif hasattr(ent, 'link'):
			ent_title = valid_fname(ent.link)
		else:
			ent_title = str(ctime())
		ent_link = 'no link :('
		if hasattr(ent, 'link'):
			ent_link = ent.link

		ent_descrip = '<no description>'
		if hasattr(ent, 'description'):
			ent_descrip = ent.description
			
		quick_save(path, str(i).zfill(3) + ' ' + valid_fname(ent_title), 
		           ent_link + '\n' + ent_descrip)
		i += 1

def parse_feed(feed_url):
	url_md5 = hashlib.md5(feed_url.encode('utf-8')).hexdigest()
	ret_str = "%s %s %s " % (url_md5, feed_url, ctime())

	socket.setdefaulttimeout(25)
	feed = feedparser.parse(feed_url)
	if feed.bozo:
		print('likely to be bad-formed.')
		# do not return, try our best
		# return ret_str + ret_bad 

	l = len(feed.entries)
	content_md5 = ''
	if l > 0:
		if hasattr(feed.entries[0], 'title'):
			stamp = feed.entries[0].title
			content_md5 = hashlib.md5(stamp.encode('utf-8')).hexdigest()
		elif hasattr(feed.entries[0], 'link'):
			stamp = feed.entries[0].link
			content_md5 = hashlib.md5(stamp.encode('utf-8')).hexdigest()
		else:
			content_md5 = hashlib.md5('empty'.encode('utf-8')).hexdigest()
	else:
		content_md5 = hashlib.md5('empty'.encode('utf-8')).hexdigest()
		print('opps, one feed is unreachable!')
		time.sleep(5)
		return ret_str + ret_bad 

	os.system('mkdir -p %s/timestamp' % cur_dir)
	time_file = cur_dir + "/timestamp/" + url_md5 + '.timestamp'
	if not os.path.exists(time_file):
		print("one new feed url added: " + url_md5)
	else:
		old_md5 = open(time_file).read()
		if content_md5 == old_md5:
			return ret_str + ret_no_update
		else:
			print("one feed url updated.")
	save_feed(feed)
	os.system("echo -n %s > %s" % (content_md5, time_file))
	return ret_str + ret_updated

if len(sys.argv) == 2:
	parse_feed(str(sys.argv[1]))
	quit()

os.system('mkdir -p %s/feed-log' % home)
log_file_path = home + '/feed-log/%s.log' % ctime()
log_file = open(log_file_path, 'w')
feed_list_path = cur_dir + "/list/*.list"
feed_lists = glob.glob(feed_list_path)
for li_name in feed_lists:
	with open(li_name, 'r') as f:
		print("reading feed list `%s'..." % li_name)
		lines = f.readlines()
		now = 1
		total = len(lines)
		for line in lines:
			url = line.rstrip()
			print('[ %s ] \t %d / %d' % (url, now, total))
			now += 1
			ret_str = parse_feed(url)
			log_file.write(ret_str + '\n')
			log_file.flush()
log_file.close()
print("log file: '%s'" % log_file_path)
