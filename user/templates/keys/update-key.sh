#!/bin/sh

[ $# == 0 ] && (echo "sh $0 acc1 acc2 ... accn"; exit)


for i in $*; do
    ssh-keygen -q -t rsa -b 2048 -f $i.id_rsa -N "" -C "$i@$(date +%F_%T)"
    \cp -rp $i.id_rsa.pub ../$i"_authorized_keys.erb"
done

exit 0
