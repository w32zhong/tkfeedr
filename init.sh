#!/bin/sh
script_dir="$(cd `dirname $0` && pwd)"
bin_dir=/usr/local/bin
uniq_name=tk-feed-open
open_script=${uniq_name}.sh
fetch_script=tk-feed-fetch.py
add_script=tk-feed-add.sh
app_dir=/usr/share/applications
mime_dir=/usr/share/mime
pkg_dir=$mime_dir/packages
feed_ext=tkfd

# check if we have root permission
touch /root/test || exit

colorpri() {
	tput setaf 2
	echo $1
	tput sgr0
}

colorpri "symbol link global command: $open_script"
ln -sf "$script_dir/$open_script" "$bin_dir/$open_script"

colorpri "symbol link global command: $fetch_script"
ln -sf "$script_dir/$fetch_script" "$bin_dir/$fetch_script"

colorpri "symbol link global command: $add_script"
ln -sf "$script_dir/$add_script" "$bin_dir/$add_script"
#exit

colorpri "adding mime file: ${pkg_dir}/application-x-${uniq_name}.xml"
mkdir -p ${pkg_dir}
cat << EOF | tee ${pkg_dir}/application-x-${uniq_name}.xml 
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
<mime-type type="application/x-${uniq_name}">
<comment></comment>
<icon name="application-x-${uniq_name}"/>
<glob-deleteall/>
<glob pattern="*.${feed_ext}"/>
</mime-type>
</mime-info>
EOF

colorpri "adding application file: ${app_dir}/${uniq_name}.desktop"
mkdir -p ${app_dir}
cat << EOF | tee ${app_dir}/${uniq_name}.desktop
[Desktop Entry]
Name=tk feed open
Comment=
Encoding=UTF-8
Exec=${open_script} %f
Icon=utilities-terminal
Type=Application
Terminal=false
MimeType=application/x-${uniq_name};
Categories=GNOME;GTK;Utility;TextEditor;
EOF

colorpri "update default app database..."
echo update-desktop-database $app_dir
update-desktop-database $app_dir
echo update-mime-database $mime_dir
update-mime-database $mime_dir

colorpri "see if mime cache has it"
cat ${app_dir}/mimeinfo.cache | grep --color feed 
