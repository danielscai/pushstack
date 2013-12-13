#
# Sample scripted installation file
# for ESXi 5+
#

vmaccepteula
reboot --noeject
rootpw welcome

install --firstdisk --overwritevmfs
clearpart --firstdisk --overwritevmfs

$SNIPPET('network_config_esxi')

%pre --interpreter=busybox

$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')

%post --interpreter=busybox

$SNIPPET('kickstart_done')
