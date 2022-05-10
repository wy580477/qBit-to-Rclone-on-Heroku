#!/bin/sh

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/data/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${RCLONE_DRIVE_NAME}" = "auto" ]; then
    DRIVENAME=${DRIVE_NAME_AUTO}
else
    DRIVENAME=${RCLONE_DRIVE_NAME}
fi

REMOTE_PATH="${DRIVENAME}:${RCLONE_UPLOAD_DIR}"
FILE_NAME="$(basename "$1")"
FILE_PATH="$(echo $1 | sed 's:[^/]*$::')"

if [ "${RCLONE_AUTO_MODE}" = "move" ]; then
    if [ -f "$1" ]; then
        rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:61802 operations/movefile srcFs="${FILE_PATH}" srcRemote="${FILE_NAME}" dstFs="${REMOTE_PATH}" dstRemote="${FILE_NAME}" _async=true
        EXIT_CODE=$?
        if [ ${EXIT_CODE} -eq 0 ]; then
            echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
        else
            echo "[ERROR] Failed to send job to rclone: $1"
        fi
    else
        rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:61802 sync/move srcFs="$1" dstFs="${REMOTE_PATH}"/"$2" _async=true
        EXIT_CODE=$?
        if [ ${EXIT_CODE} -eq 0 ]; then
            echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
        else
            echo "[ERROR] Failed to send job to rclone: $1"
        fi
    fi
elif [ "${RCLONE_AUTO_MODE}" = "copy" ]; then
    if [ -f "$1" ]; then
        rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:61802 operations/copyfile srcFs="${FILE_PATH}" srcRemote="${FILE_NAME}" dstFs="${REMOTE_PATH}" dstRemote="${FILE_NAME}" _async=true
        EXIT_CODE=$?
        if [ ${EXIT_CODE} -eq 0 ]; then
            echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
        else
            echo "[ERROR] Failed to send job to rclone: $1"
        fi
    else
        rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:61802 sync/copy srcFs="$1" dstFs="${REMOTE_PATH}"/"$2" _async=true
        EXIT_CODE=$?
        if [ ${EXIT_CODE} -eq 0 ]; then
            echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
        else
            echo "[ERROR] Failed to send job to rclone: $1"
        fi
    fi
else
    :
fi
