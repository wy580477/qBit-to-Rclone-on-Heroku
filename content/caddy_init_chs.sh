#!/bin/sh

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/data/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${RCLONE_DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
else
    DRIVENAME=${RCLONE_DRIVE_NAME}
fi

if [ "${RCLONE_AUTO_MODE}" = "custom" ]; then
    sed -i "s|MODE_STATUS|<b>[custom] 自定义qbittorrent下载后执行命令</b>|g" /workdir/homer/assets/config.yml
elif [ ! -f "/mnt/data/config/rclone.conf" ]; then
    sed -i "s|MODE_STATUS|<b>未找到 Rclone 配置文件</b>|g" /workdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "move" ]; then
    sed -i "s|MODE_STATUS|<b>[move] qbittorrent下载任务完成后移动到Rclone远程存储${DRIVENAME}:${RCLONE_UPLOAD_DIR}</b>|g" /workdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "copy" ]; then
    sed -i "s|MODE_STATUS|<b>[copy] qbittorrent下载任务完成后复制到Rclone远程存储${DRIVENAME}:${RCLONE_UPLOAD_DIR}</b>|g" /workdir/homer/assets/config.yml
fi
