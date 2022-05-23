## Warning | 警告
   2022/5/21

- Unmaintained repo | 停止维护
- Deploy at your own risk | 部署风险自负
- Checkout [Heroku-AIO-APP-EX](https://github.com/wy580477/Heroku-AIO-APP-EX)

[点击前往中文说明](https://github.com/wy580477/qBit-to-Rclone-on-Heroku/blob/main/README_chs.md)

## Acknowledgments

- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  Inspiration for this project.
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  A very simple static homepage for your server.
- [userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static) | [WDaan/VueTorrent](https://github.com/WDaan/VueTorrent) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [rclone/rclone](https://github.com/rclone/rclone)

## Attention

 1. **Do not abuse heroku's service, or your account could get banned.**
 2. qBittorrent download speed is limited to 5MB/s on default.
 3. Anyone who can login into this app has full access to data in this app and Rclone remotes. Do not share with other ppl, and do not store sensitive information with this app.

[Overview](#Overview)

[Deployment](#Deployment)

[First run](#first)  

[More usages and precautions](#more)  

## <a id="Overview"></a>Overview

This project integrates qBittorrent + VueTorrent WebUI, Rclone + WebUI with auto-upload function, Rclone Serve HTTP & Webdav, customizable portal page, Filebrowser, ttyd web terminal.

[yt-dlp+aria2 version](https://github.com/wy580477/Heroku-All-In-One-APP)

![image](https://user-images.githubusercontent.com/98247050/167996044-9c313c4a-6bbb-461d-88f2-2c4034f216f7.png)

 1. Rclone auto-upload function only needs to prepare rclone.conf file, and all other configurations are set to go.
 2. Rclone runs on daemon mode, easy to manually transfer files and monitor transfers in real time on WebUI.
 3. You can connect qBittorrent and Rclone from frontends running on other hosts.
 4. Auto-backup configuration files to Rclone remote, and try to restore from Rclone remote when dyno restarts.
 5. There are independent logs for each service in the log directory.

## <a id="Deployment"></a>Deployment

 **Do not deploy directly from this repository**  

 1. Fork this this repository.
 2. Click Setting on fork repository page and check Template repository.
 3. Click new button: Use this template，create a new repository。
 4. For example, your Github username is bobby, and the new repository name is green. After logging in to heroku, visit <https://dashboard.heroku.com/new?template=https://github.com/bobby/green> to deploy.

## <a id="first"></a>First run

 1. After deployment, for example, your heroku domain name is bobby.herokuapp.com, the portal page path is /portal, then visit bobby.herokuapp.com/portal to reach the portal page.
 2. Click qBittorrent or VueTorrent, then login in with default user admin and default password adminadmin. Change default user/password to your own, Recommend strong password.
 3. Rclone Webdav address: your_Heroku_domain/${GLOBLA_PORTAL_PATH}/rclonedav

## <a id="more"></a>More usages and precautions

 1. Hit shift+F5 to force refresh if web services don't work properly. If app still doesn't work, clear cache and cookie of your heroku domain from browser.
 2. Heroku has ephemeral filesystem，although configuration files are automatically back up to Rclone remote and attempted to be restored after dyno restarted, any changes other than Config Vars are recommended to be modified in the github repository before deployment.
 3. Move ${HEROKU_APP_NAME} folder in your Rclone remote to new remote if you are going to change Rclone remote, otherwise you will lose your qBittorrent and filebrowser settings.
 4. How to modify Heroku Config Vars: Click setting on Heroku app page, then click Reveal Config Vars to modify.
 5. Add the following content to the end of the Rclone config file, you can add local heroku storage in Rclone Web UI for manual upload.

```
[local]
type = alias
remote = /mnt/data
```

 6. It is not possible to configure a Rclone remote which requires web authentication through Rclone web UI in this app.
 7. Under content directory in repository, qbit.conf is qBittorrent config file.
 8. Portal page config file homer_en.yml and icon resources are under content/homer_conf directory in repository, use path as ./assets/tools/example.png to add the new icon to homer config file.
