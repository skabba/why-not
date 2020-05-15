#!/bin/bash

### Create a 40GB BTRFS image file to mount later via a loopback device
### Run in background with '&' at the end
mkdir -p /opt/concourse/worker/volumes
dd if=/dev/zero of=/opt/concourse/worker/btrfs.img bs=4k count=1000000 &

### Check if the 'dd' command finished and mount BTRFS filesystem
if ps -p $! >& /dev/null
then
  wait $!
  modprobe btrfs
  mkfs.btrfs /opt/concourse/worker/btrfs.img
  losetup /dev/loop0 /opt/concourse/worker/btrfs.img
  mount -t btrfs /dev/loop0 /opt/concourse/worker/volumes
fi
