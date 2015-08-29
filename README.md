*one-script feed reader*
![feed](https://raw.githubusercontent.com/t-k-/one-script-feed-reader/master/img/feed.png)

# About
This is a dead-simple one-script feed reader which helps you fetch your RSS/Atom feeds in a more controllable way and read your feeds in files rather than relying on a really-slow public reader service and you-can-do-nothing WEB interface. 

Be aware for its simplicity (it is for my personal use), but also to believe: It is sufficient for a feed reader.

# Try it out first! 
You won't need much time to write such a simple script, but following are quick instructions (assuming you are an Ubuntu user) that just to give you a better idea on how it is used and let you to decide if you like your feed reader in a simple way.

## Step 0
Open your terminal downloading/installing everything:

```bash
git clone --depth 1 https://github.com/t-k-/one-script-feed-reader.git
sudo apt-get install python-pip
sudo pip install feedparser
cd ./one-script-feed-reader
```

## Step 1
Write your **.list** extension files  in `./feedlist/` directory with each file contains lines of feed URLs that you want to be fetched.

I already put some **.list** files of my personal favorite feed sites into that directory, so this step is optional. Skip it, and you will still see it working.

## Step 2
Run the fetch script: `./fetch.py` and wait for the script to finish...  :icecream:

![fetching](https://raw.githubusercontent.com/t-k-/one-script-feed-reader/master/img/screenshot0.png)

## Step 3
Read your feeds in `./feeds` directory. BTW, this is the final step.

![reading](https://raw.githubusercontent.com/t-k-/one-script-feed-reader/master/img/screenshot1.png)

![reading](https://raw.githubusercontent.com/t-k-/one-script-feed-reader/master/img/screenshot2.png)

# Notice 
+ You can use the included `opml2feedlist.sh` script to convert an **import.opml** file to a **.list** file.
+ `./log` directory contains log files which is the best place where you can find out which feed URL is old and not updating anymore. 
+ `./timestamp` is the directory where feed content (more precisely the title string or URL of the first item in one feed) HASH is saved to be compared in order to know whether the content is updated and should be downloaded.
+ No license is using here, you can freely use this script only if you like it. But helping me improve it is much welcome, the author's contact information can be found below.

# Contact the author 
Email: clock126@126.com
