clear
wait_time=10

########## Ubuntu ##########
pkg="apt"
old_pkg="apt-get"
f_addrepo="add-apt-repository -y"
f_update="update -y"
f_ugrade="dist-upgrade -fy"
f_install="install -fy"
f_clean="autoclean -y"
f_remove="autoremove -y"

echo "pkg = $pkg
old_pkg = $old_pkg
f_addrepo = $f_addrepo
f_update = $f_update
f_ugrade = $f_ugrade
f_install = $f_install
f_clean = $f_clean
f_remove = $f_remove"

echo ""
read -t $wait_time -p "Waiting $wait_time seconds only ..."
echo ""

##############################