#!/bin/sh

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/data/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${RCLONE_DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
else
    DRIVENAME=${RCLONE_DRIVE_NAME}
fi

if [ "${RCLONE_AUTO_MODE}" = "custom" ]; then
    sed -i "s|MODE_STATUS|<b>[custom]</b>|g" /workdir/homer/assets/config.yml
elif [ ! -f "/mnt/data/config/rclone.conf" ]; then
    sed -i "s|MODE_STATUS|<b>Fail to find Rclone config file</b>|g" /workdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "move" ]; then
    sed -i "s|MODE_STATUS|<b>[move] Move files to Rclone remote ${DRIVENAME}:${RCLONE_UPLOAD_DIR} on torrent completion</b>|g" /workdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "copy" ]; then
    sed -i "s|MODE_STATUS|<b>[copy] Copy files to Rclone remote ${DRIVENAME}:${RCLONE_UPLOAD_DIR} on torrent completion</b>|g" /workdir/homer/assets/config.yml
fi