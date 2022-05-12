#!/bin/sh

DIR_TMP="$(mktemp -d)"

# Install Rclone
VERSION="$(curl --retry 10 --retry-max-time 60 https://api.github.com/repos/rclone/rclone/releases/latest | jq .tag_name | sed 's/\"//g')"
wget -qO - https://github.com/rclone/rclone/releases/download/${VERSION}/rclone-${VERSION}-linux-amd64.zip | busybox unzip -qd ${DIR_TMP} -
install -m 755 ${DIR_TMP}/rclone-${VERSION}-linux-amd64/rclone /usr/bin
rm -rf ${DIR_TMP}

# Install qibttorrent
wget -qO /workdir/qbit https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/x86_64-qbittorrent-nox
chmod +x /workdir/qbit

# Install Vuetorrent
wget -qO - https://github.com/WDaan/VueTorrent/releases/latest/download/vuetorrent.zip | busybox unzip -qd /workdir -