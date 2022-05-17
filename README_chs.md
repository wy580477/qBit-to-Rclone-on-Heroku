## 鸣谢

- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  启发了本项目的总体思路。
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  使用yaml配置文件的静态导航页，便于自定义。
- [userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static) | [WDaan/VueTorrent](https://github.com/WDaan/VueTorrent) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

## 注意

 1. **请勿滥用，重度使用可能导致账号被封。**
 2. Heroku的文件系统是临时性的，每24小时强制重启一次后会恢复到部署时状态。不适合长期BT下载和共享文件用途。
 3. qBittorrent配置文件默认限速5MB/s。
 4. 所有可以登陆此APP的用户可以访问/修改此APP以及Rclone远程存储的所有数据，不要存放敏感数据，不要与他人共享使用。
 5. 免费Heroku dyno半小时无Web访问会休眠，可以使用[hetrixtools](https://hetrixtools.com/uptime-monitor/215727.html)这样的免费VPS/网站监测服务定时http ping，保持持续运行。

[概述](#概述)

[部署方式](#部署方式)

[变量设置](#变量设置)  

[初次使用](#初次使用)  

[更多用法和注意事项](#更多用法和注意事项)  

## 概述

本项目集成了qBittorrent和其Web前端VueTorrent、Rclone+WebUI、Rclone联动自动上传功能、Rclone远程存储文件列表和Webdav服务、可自定义的导航页、Filebrowser轻量网盘、ttyd Web终端。

[yt-dlp+aria2版本传送门](https://github.com/wy580477/Heroku-All-In-One-APP)

![image](https://user-images.githubusercontent.com/98247050/167992882-5b874f48-1c69-4abf-b663-986ab52fdd42.png)

 1. 联动上传功能只需要准备rclone.conf配置文件, 其他一切配置都预备齐全。
 2. Rclone以daemon方式运行，可在WebUI上手动传输文件和实时监测传输情况。
 3. qBittorrent和Rclone可以接入其它host上运行的前端面板。
 4. 自动备份配置文件到Rclone远程存储，dyno重启时尝试从远程恢复.。
 5. log目录下有每个服务独立日志。

## 部署方式

 **请勿使用本仓库直接部署**  

  **Heroku修复安全漏洞中，目前无法通过网页从私有库部署**  

 1. 点击右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 比如你的Github用户名是bobby，新库名称是green。浏览器登陆heroku后，访问<https://dashboard.heroku.com/new?template=https://github.com/bobby/green> 即可部署。

### 变量设置

对部署时可设定的变量做如下说明。
| 变量| 说明 |
| :--- | :--- |
| `GLOBAL_USER` | 用户名，适用于除qBittorrent外所有需要输入用户名的页面 |
| `GLOBAL_PASSWORD` | 务必修改为强密码，同样适用于除qBittorrent外所有需要输入密码的页面，同时也是Aria2 RPC密钥。 |
| `GLOBAL_LANGUAGE` | 设置qBittorrent、导航页和Filebrowser界面语言，chs为中文 |
| `GLOBAL_PORTAL_PATH` | 导航页路径和所有Web服务的基础URL，相当于密码之外多一层保护。不能为“/"和空值，结尾不能加“/" |
| `RCLONE_CONFIG_BASE64` | Rclone配置文件Base64编码，可使用linux系统base64命令或者在线base64工具生成。注意，多远程存储Rclone配置文件可能超过Heroku变量32kb的上限。 |
| `RCLONE_DRIVE_NAME` | Rclone远程存储配置名称，后面不要加冒号。默认值auto将从配置文件第一行中提取 |
| `RCLONE_AUTO_MODE` | 控制qBittorrent与Rclone联动模式，move为任务完成后移动到Rclone远程存储，copy则为复制，custom为自定义。 |
| `RCLONE_UPLOAD_DIR` | Rclone自动上传目标目录。 |
| `TZ` | 时区，Asia/Shanghai为中国时区 |
| `HEROKU_API_KEY` | Heroku账号API密钥，可选项，用于从dyno内部更新rclone配置文件变量，解决rclone token过期问题。需要HEROKU_APP_NAME和HEROKU_RESTART_TIME变量配合，而且dyno在指定的HEROKU_RESTART_TIME必须正在运行。可从Heroku账号面板处获得，也可以用heroku cli命令heroku authorizations:create创建。 |
| `HEROKU_APP_NAME` | Heroku APP名称。 |
| `HEROKU_KEEP_AWAKE` | 设置为"true"可以阻止dyno空闲时休眠，需要HEROKU_APP_NAME变量配合。 |
| `HEROKU_RESTART_TIME` | 指定更新Rclone配置文件的时间，可选项，在指定的时间正在运行的dyno会重启。格式为6:00，24小时制，时区为TZ变量所指定的时区。 |

### 初次使用

 1. 部署完成后，比如你的heroku域名是bobby.herokuapp.com，导航页路径是/portal，访问bobby.herokuapp.com/portal 即可到达导航页。
 2. 点击qBittorrent或者VueTorrent，输入默认用户名admin和默认密码adminadmin登陆。然后更改用户名和密码，务必设置为强密码。
 3. Rclone Webdav 地址：Heroku_app域名/${GLOBAL_PORTAL_PATH}/rclonedav

### 更多用法和注意事项

 1. 如果网页访问APP出现故障，按下shift+F5强制刷新，如果还不行，从浏览器中清除app对应的heroku域名缓存和cookie。
 2. Heroku每24小时重启后恢复到部署时文件系统，尽管config文件夹下配置文件会自动备份和尝试恢复，除了变量外任何改动都建议在部署前在github仓库内修改。
 3. 如果要更改Rclone远程存储，需要将远程存储中${HEROKU_APP_NAME}文件夹移动到新的远程存储，不然会丢失qBittorrent和filebrowser的设置。
 4. 修改Heroku app变量方法：在Heroku app页面上点击setting，再点击Reveal Config Vars即可修改。
 5. Rclone配置文件末尾加上如下内容，可以在Rclone Web前端中挂载本地存储，方便手动上传。

```
[local]
type = alias
remote = /mnt/data
```

 6. 无法通过Rclone Web前端建立需要网页认证的存储配置。
 7. content目录下，qbit.conf为qBittorrent配置文件。
 8. content/homer_conf目录下是导航页设置文件homer_chs(en).yml和图标资源，新加入的图标，在设置文件中要以./assets/tools/example.png这样的路径调用。
