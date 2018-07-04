# base-docker-env，面向生产和开发环境的LNP基础镜像

这是一份适用于生产和开发环境的 **Dockerfile**。 在 [phuison/baseimage](https://github.com/phusion/baseimage-docker "phusion的baseimage-docker") 的基础上，增加了php、php扩展和nginx的安装脚本, 实现了一键安装LNP及其常用扩展的功能。目前已经在我司的生产环境上并运行良好。日常开发中也是基于此镜像进行的。

## 镜像内容

此镜像包括如下内容：

- Ubuntu 16.04 LTS
	- A correct init process
	- syslog-ng	
	- logrotate
	- SSH server
	- cron
	- [runit](http://smarden.org/runit/)
	- setuser
	- install_clean


> 以上这部分内容请移步到 [这里](https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md) 查看注释。

- re2c-1.0.3
- php 7.1.18
- php-swoole-2.2.0
- php-yaml-2.0.2
- php-mongodb-1.4.2
- php-redis-4.0.1
- php-imagick-3.4.3
- php-xdebug-2.6.0
- php-igbinary-2.0.5
- php-memcached-3.0.4
- php-yac-2.0.2
- php-inotify-2.0.0
- hiredis-0.13.3
- libmemcached-1.0.18
- ImageMagick
- nginx-1.12.2

以上安装脚本分别在 `build/php_7.1.18.sh` 和 `build/nginx_1.12.2.sh` 中。

APT这块使用了清华大学的ubuntu安装源。 此部分代码可在 `build/prepare.sh` 中找到。

## 安装与运行

**使用基于docker的开发和生产环境需要你有基础的docker知识。这里假设你已经了解镜像，容器，以及容器编排的一些概念并且实际使用过。**

### 构建

`git clone` 此仓库，在 **Dockerfile** 所在的目录执行命令： 

	docker build -t='[ImageName]:[Tag]' .    // [ImageName] 为你想要的镜像名称,如果不想标识版本，请忽略:[Tag]。但是别忽略了"."

然后等待构建成功即可。整个安装过程约10-15分钟，取决于你当前所在的网络环境。

### 在线仓库

如果不想构建，也可以使用我已经打包好的在线仓库。

    docker pull ccr.ccs.tencentyun.com/qyy-base/qyy-php:1.1.0

### 运行

通过构建或者在线拉取镜像到本地后，使用 `docker images` 查看该镜像信息。整个镜像大小为957MB，运行时占用内存约300M。

**如果想快速看看镜像里有啥东西，只需要运行:**

	docker run --rm -it [ImageID] /sbin/my_init -- bash -l  // 其中ImageID替换成你实际的镜像ID。

该命令创建容器并启动了shell，进入交互模式。**请注意：镜像里面并没有运行任何我们想要的服务（如php和nginx）,只是启动了系统并[执行了系统的初始化流程。](https://github.com/phusion/baseimage-docker/blob/master/README_ZH_cn_.md#running_startup_scripts)**

## 开发环境的使用

单独运行这个容器是没有意义的。因为这里面没有任何你的业务代码，也没有任何我们想要的服务。

下面来看看如何运用在开发环境中：

一个完整的开发环境应当包含数据库、缓存与web服务。该镜像已经包含了nginx，所以我们只需要把其他的服务跑起来即可。这里使用到了 `docker-compose` 把该镜像与其他服务链接起来并运行.

我们应该有一个目录专门放这些配置文件，假设有个目录叫 **docker-dev**,它的目录结构大概是这个样子：

	docker-dev            部署目录
	├─mysql               数据库配置目录
	│  ├─my.cnf           公共模块目录（可更改）
	│  ├─conf.d           模块目录(可更改)
	│  │  ├─my5.6.cnf     模块配置文件
	│  │  ├─mysqld_safe_syslog.cnf  模块函数文件
	│  │  └─ ...          更多类库目录
	├─nginx               Nginx配置目录
	│  ├─nginx.conf       要覆盖的nginx.conf
	├─php                 PHP配置目录
	│  ├─php-fpm.conf 	  要覆盖的php-fpm conf
	│  ├─php-fpm.ini 	  要覆盖的php-fpm.ini
	│  ├─php.d            扩展配置目录
	│  │  ├─xdebug.ini    要启用 Xdebug，在该ini文件里填入 `zend_extension=xdebug.so`
	├─redis               缓存配置目录    
	│  ├─redis.conf       要覆盖的redis.conf
	├─docker-compose.yml  docker-compose 编排文件
	├─game.sh               业务启动脚本
	├─game.conf             业务的web配置


假设我的业务代码在 `/d/WWW/gamer/game` ,是一个基于yii2的php项目。

先来看 `docker-compose.yml`，注意看注释:


	version: '2'
	services:
	  php:
	    restart: always
	    image: ccr.ccs.tencentyun.com/qyy-base/qyy-php:1.1.0
	    container_name: game
	    volumes:
	    - /d/WWW/gamer/game:/home/worker/data/www/game  # 将宿主机的代码目录映射到容器的www目录
		# ... 如果有更多的开发中业务代码，一并放到这里并映射到容器 
	    - ./php/php-fpm.ini:/home/worker/php/etc/php-fpm.ini # 用开发配置覆盖容器里的fpm配置
	    - ./php/php-fpm.conf:/home/worker/php/etc/php-fpm.conf # 同上
	    - ./php/php.d/xdebug.ini:/home/worker/php/etc/php.d/xdebug.ini # 开发环境开启xdebug。
	    - ./nginx/nginx.conf:/home/worker/nginx/conf/nginx.conf # 用开发配置覆盖容器里的nginx配置文件
	    - ./game.conf:/home/worker/nginx/conf.d/game.conf  # 业务的nginx配置。
	    - ./game.sh:/etc/my_init.d/game.sh # 业务的启动配置，一般是启动php-fpm和nginx，也可以按需写其他执行脚本
	    # 如果有更多的业务需要自定义脚本或者web，在这里添加
	    ports:
	      - "80:80" 
	    networks:
	      - new
	    depends_on:
	      - redis
	      - memcached
	      - mysql
	    extra_hosts:
	      - "gameapi.cc:192.168.1.9" # 将一个用于开发的虚拟域名指向到宿主机的IP。
	  redis:
	    restart: always
	    image:  registry.cn-hangzhou.aliyuncs.com/qyyteam/redis:1.0.0
	    ports:
	      - "6379:6379"
	    volumes:
	      - /d/persistent/redis:/data # 左边的目录是我宿主机上的持久化redis存储目录，这里换成自己的。
	      - ./redis/redis.conf:/usr/local/etc/redis/redis.conf # 用开发配置覆盖redis容器里的配置
	    networks:
	      - new 
	    container_name: redis
	  memcached:
	    restart: always
	    image: registry.cn-hangzhou.aliyuncs.com/qyyteam/memcached:1.0.0
	    ports:
	      - "11211:11211"
	    networks:
	      - new 
	    container_name: memcached
	  mysql:
	    image: registry.cn-hangzhou.aliyuncs.com/qyyteam/mysql:5.6
	    restart: always
	    ports:
	      - "3306:3306"
	    volumes:
	      - ./mysql/my.cnf:/etc/mysql/my.cnf
	      - ./mysql/conf.d:/etc/mysql/conf.d
	      - /d/server/MySql/data:/var/lib/mysql 
	      # 左边的目录是我宿主机上的持久化Mysql存储目录，这里换成一个全新的或者已经存在的数据库目录。 
	    environment:
	      - MYSQL_ROOT_PASSWORD=root
	      - MYSQL_USER=root
	      - MYSQL_PASSWORD=root
	    networks:
	      - new 
	    container_name: mysql
	networks:
	    new:


如上所示，我们有php+nginx服务，redis服务、memcached服务，mysql服务。这些服务被编排在一起，合成了一个完整的开发环境。（当然如果你的技术栈不是这样或者版本不对，可以换成自己的。这需要你有点动手能力：） ）

再来看一下 `game.sh` :

	#!/bin/sh
	set -e
	mkdir -p /home/worker/data/php/logs/xdebug
	# start nginx,php-fpm
	setuser worker /home/worker/php/sbin/php-fpm -c /home/worker/php/etc/php-fpm.ini
	/home/worker/nginx/sbin/nginx

在docker-compose.yml文件里，它被映射到了 `/etc/my_init.d/` 目录。在启动容器的时候该目录下的shell文件会按文件名顺序执行。
该脚本初始化了一个目录，并且启动了 `php-fpm` 和 `nginx` 用于接收访问。


最后在docker-compose.yml所在的目录中，命令输入：

	docker-compose -p dev up -d

便启动了所有服务。就是这么简单！最重要的是，它是一个统一的、可维护的、可在团队内普及推广的开发环境！

PS:这个例子的所有代码会在 `example/docker-game-dev` 中。

**请注意：根据自己实际需要，修改docker-compose.yml或其他服务如Mysql，redis的配置项，这只是一个例子，千万不要复制粘贴直接用。**

## 生产环境的使用

其实如果是小公司，业务量不大并且是单机的话，上面的方法里只需要将配置变量改成生产环境的就能直接用。

但如果：

- 是分布式应用
- 使用了容器服务（Kubernetes或者swarm）
- 有CI && CD的需求

就必须把你的业务代码打包成一个镜像了。还是假设项目目录为 /d/WWW/gamer/www, 在该目录下新建一个 `Dockerfile` :

	FROM ccr.ccs.tencentyun.com/qyy-base/qyy-php:1.1.0
	MAINTAINER banyan.cheung@gmail.com
	
	# source codes
	RUN mkdir -p /home/worker/data/www/game
	COPY . /home/worker/data/www/game
	
	# startup scripts
	COPY docker/game.sh /etc/my_init.d/game.sh
	RUN chmod +x /etc/my_init.d/game.sh
	
	# php-fpm configs
	COPY docker/php-fpm.ini /home/worker/php/etc/php-fpm.ini
	COPY docker/php-fpm.conf /home/worker/php/etc/php-fpm.conf
	
	# logrotate
	COPY docker/nginx /etc/logrotate.d/nginx
	COPY docker/php-fpm /etc/logrotate.d/php-fpm
	RUN chmod 644 /etc/logrotate.d/nginx
	RUN chmod 644 /etc/logrotate.d/php-fpm
	
	EXPOSE 80

这个Dockerfile继承了基础镜像，还做了它独有的其他事情： 

- 将代码Copy进了镜像里的www目录
- 新增了启动脚本，替换了原有的php-fpm和ini配置
- 配置了 `logrotate` 每隔一段时间分割nginx和php产生的日志文件

相信你已经举一反三了————每一个独立的业务代码都应该像这样构建属于自己的镜像。构建成功后，就能方便的进行分布式部署和CI && CD了。

## 一些文件及路径的位置

虽然我已经尽可能考虑到各种情况，但是每个公司每个团队的情况都不一样，适用我的不一定适用于你。这里我列出一些在镜像里你可能需要了解的地方，以方便你进行定制：

`/home/worker/data` 目录是数据目录，这里面放一些诸如你的代码、日志的东东。

`/home/worker/data/www` 是固定的web目录。当然你可以在 config/php/etc/php-fpm.ini 中修改它。

下面是一些固定的文件路径：

`/home/worker/data/php/logs/php_errors.log` php的错误日志

`/home/worker/data/php/logs/opcache_errors.log` opcache 错误日志

`/home/worker/data/php/run/php-fpm.pid`  php pid 地址。

`/home/worker/data/php/logs/php-fpm.log` php-fpm 日志。

`/home/worker/data/php/logs/www.access.log` access log

以上这些都可以在 config/php/etc/php-fpm.ini 和 config/php/etc/php-fpm.conf 中修改。


php 安装在 `/home/worker/php` 中。打开它你会发现熟悉的php安装目录。
nginx 安装在 `/home/worker/nginx` 中。conf目录是 `/home/worker/nginx/conf.d/`

如果需要使用 `logrotate` , 请写一个配置文件在Dockerfile里COPY到 `/etc/logrotate.d/`，并将权限修改为644。这里是一个例子：

/etc/logrotate.d/nginx

	/home/worker/data/nginx/logs/*.log {
	    daily
	    missingok
	    rotate 7
	    compress
	    delaycompress
	    notifempty
	    dateext
	    postrotate
	        if [ -f /home/worker/data/nginx/logs/nginx.pid ]; then
	                kill -USR1 `cat /home/worker/data/nginx/logs/nginx.pid`
	        fi
	    endscript
	}


定时任务可以写shell放在 `/etc/cron.hourly/`,`/etc/cron.daily/`,`/etc/cron.weekly/`等文件夹中，系统会根据时间自动执行。  `cat /etc/crontab` 可以看到系统自带的定时任务设置。



希望能帮到你。