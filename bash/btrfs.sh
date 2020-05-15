#!/usr/bin/env bash
### Purpose: Use a loop device to setup Btrfs filesystem without cost.
###          You don't have to purchase a hard drive.
### Author:  Enri Peters
### Date:    May 15 2020

## Install packages
## Create mount folder
yum install -y btrfs-progs
mkdir -p /mnt/btrfs /opt/btrfs

### Create a 40GB image file to mount later via a loopback device
### Run in background with '&' at the end
dd if=/dev/zero of=/opt/btrfs/btrfs.img bs=4k count=1000000 &

### Check if the 'dd' command finished and mount BTRFS filesystem
if ps -p $! >& /dev/null
then
  wait $!
  modprobe btrfs
  mkfs.btrfs /opt/btrfs/btrfs.img
  losetup /dev/loop0 /opt/btrfs/btrfs.img
  mount -t btrfs /dev/loop0 /mnt/btrfs
fi
