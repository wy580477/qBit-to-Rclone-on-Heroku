#!/bin/sh

mkdir -p /mnt/data/config /mnt/data/downloads
echo ${RCLONE_CONFIG_BASE64} | base64 -d  >/mnt/data/config/rclone.conf

exec runsvdir -P /etc/service