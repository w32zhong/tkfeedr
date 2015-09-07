#!/bin/sh
script_dir="$(cd `dirname $0` && pwd)"
bin_dir=/usr/local/bin
uniq_name=my-feed-open
open_script=${uniq_name}.sh
open_app=${uniq_name}.desktop
mime_dir=/home/tk/.local/share/mime/packages
feed_ext=tkfd

# check if we have root permission
touch /root/test || exit

echo "symbol link global command..."
ln -sf "$script_dir/$open_script" $bin_dir/$open_script

echo "adding ${open_app}..."

cat << EOF | tee ${open_app}
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=${uniq_name}
Exec=touch /tmp/abc
Terminal=true
EOF
#echo ${open_script} %f > /tmp/abc

echo "adding mime xml..."
mkdir -p ${mime_dir} 
cat << EOF | tee ${mime_dir}/application-x-foobar.xml 
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
<mime-type type="application/x-foobar">
<comment>foo file</comment>
<icon name="application-x-foobar"/>
<glob-deleteall/>
<glob pattern="*.${feed_ext}"/>
</mime-type>
</mime-info>
EOF

echo "update default app database..."
update-desktop-database ~/.local/share/applications
update-mime-database    $mime_dir
