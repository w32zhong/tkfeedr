#!/bin/sh
script_dir="$(cd `dirname $0` && pwd)"
bin_dir=/usr/local/bin
uniq_name=my-feed-open
open_script=${uniq_name}.sh
open_app=${uniq_name}.desktop

# check if we have root permission
touch /root/test || exit

echo "symbol link global command..."
ln -sf "$script_dir/$open_script" $bin_dir/$open_script

echo "writing /usr/share/applications/${open_app}"

cat << EOF | tee /usr/share/applications/${open_app}
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=${uniq_name}
Exec=touch /tmp/abc
Terminal=true
EOF
#echo ${open_script} %f > /tmp/abc
