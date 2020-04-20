#!/bin/bash
RED="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
isRoot(){
  if [[ "$EUID" -ne 0 ]]; then
    echo "false"
  else
    echo "true"
  fi
}
genId(){
    id1=$(cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-8)
    id2=$(cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-4)
    id3=$(cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-4)
    id4=$(cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-4)
    id5=$(cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-12)
    id=$id1'-'$id2'-'$id3'-'$id4'-'$id5
    echo "$id"
}
mgr(){
  isRoot=$( isRoot )
  if [[ "${isRoot}" != "true" ]]; then
    echo -e "${RED_COLOR}error:${NO_COLOR}Please run this script as as root"
    exit 1
  else
      #=========安装的trojan+caddy+tls一键脚本==============================
      if [ -e "/usr/local/bin/caddy" -a -e "/usr/local/bin/trojan" ]; then
            echo -e "
      $FUCHSIA===================================================
      ${GREEN}系统检测到您目前安装的是trojan+caddy+tls一键脚本
      $FUCHSIA===================================================
      ${GREEN}1. 停止trojan             ${GREEN}2. 重启trojan
      $FUCHSIA===================================================
      ${GREEN}3. 修改trojan密码         ${GREEN}4. 停止caddy
      $FUCHSIA===================================================
      ${GREEN}5. 重启caddy             ${GREEN}0. 退出
      $FUCHSIA===================================================${NO_COLOR}"
      read -p "请输入您要执行的操作的数字:" aNum
      case $aNum in
          1)systemctl stop trojan
            echo -e  "${GREEN}trojan服务停止${NO_COLOR}"
          ;;
          2)systemctl restart trojan
            echo -e  "${GREEN}trojan服务启动${NO_COLOR}"
          ;;
          3)systemctl stop trojan
            if [ -f "/usr/local/etc/trojan/config.json" ]; then
                read -p "新密码：" password
                while [ "${password}" = "" ]; do
                      read -p "密码不能为空，请重新输入：" password
                done
                sed -i "8c \"$password\"," /usr/local/etc/trojan/config.json
                systemctl start trojan
                echo -e  "${GREEN}恭喜你，密码修改成功${NO_COLOR}"
                sed -i "/密码/c 密码:        $password" /etc/motd
            else
                echo -e  "${RED}很遗憾，Trojan配置文件不存在${NO_COLOR}"
            fi
            systemctl start trojan
          ;;
          4)caddy -service stop
            echo -e  "${GREEN}caddy服务停止${NO_COLOR}"
          ;;
          5)caddy -service restart
            echo -e  "${GREEN}caddy服务启动${NO_COLOR}"
          ;;
          0) exit
          ;;
          *)echo -e "${RED}输入错误！！！${NO_COLOR}"
            exit
          ;;
      esac
      fi
      #=========安装的trojan+nginx+tls一键脚本===============================
      if [ -e "/usr/sbin/nginx" -a -e "/usr/local/bin/trojan" ]; then
            echo -e "
      $FUCHSIA===================================================
      ${GREEN}系统检测到您目前安装的是trojan+nginx+tls一键脚本
      $FUCHSIA===================================================
      ${GREEN}1. 停止trojan          ${GREEN}2. 重启trojan
      $FUCHSIA===================================================
      ${GREEN}3. 修改trojan密码      ${GREEN}4. 停止nginx
      $FUCHSIA===================================================
      ${GREEN}5. 重启nginx           ${GREEN}0. 退出
      $FUCHSIA===================================================${NO_COLOR}"
      read -p "请输入您要执行的操作的数字:" aNum
      case $aNum in
          1)systemctl stop trojan
            echo -e  "${GREEN}trojan服务停止${NO_COLOR}"
          ;;
          2)systemctl restart trojan
            echo -e  "${GREEN}trojan服务启动${NO_COLOR}"
          ;;
          3)systemctl stop trojan
             if [ -f "/usr/local/etc/trojan/config.json" ]; then
                read -p "新密码：" password
                while [ "${password}" = "" ]; do
                      read -p "密码不能为空，请重新输入：" password
                done
                sed -i "8c \"$password\"," /usr/local/etc/trojan/config.json
                systemctl start trojan
                echo -e  "${GREEN}恭喜你，密码修改成功${NO_COLOR}"
                sed -i "/密码:/c 密码:        $password" /etc/motd
            else
                echo -e  "${RED}很遗憾，Trojan配置文件不存在${NO_COLOR}"
            fi
            systemctl start trojan
          ;;
          4)nginx -s stop
            echo -e  "${GREEN}nginx服务停止${NO_COLOR}"
          ;;
          5)nginx
            echo -e  "${GREEN}nginx服务启动${NO_COLOR}"
          ;;
          0) exit
          ;;
          *)echo -e "${RED}输入错误！！！${NO_COLOR}"
            exit
          ;;
      esac
      fi
      #=========安装的v2ray+caddy+tls一键脚本==============================
      if [ -e "/usr/local/bin/caddy" -a -e "/usr/bin/v2ray/v2ray" ]; then
            echo -e "
      $FUCHSIA===================================================
      ${GREEN}系统检测到您目前安装的是v2ray+caddy+tls一键脚本
      $FUCHSIA===================================================
      ${GREEN}1. 停止v2ray      ${GREEN}2. 重启v2ray
      $FUCHSIA===================================================
      ${GREEN}3. 修改UUID       ${GREEN}4. 停止caddy
      $FUCHSIA===================================================
      ${GREEN}5. 重启caddy      ${GREEN}0. 退出
      $FUCHSIA===================================================${NO_COLOR}"
      read -p "请输入您要执行的操作的数字:" aNum
      case $aNum in
          1)service v2ray stop
            echo -e  "${GREEN}v2ray服务停止${NO_COLOR}"
          ;;
          2)service v2ray restart
            echo -e  "${GREEN}v2ray服务启动${NO_COLOR}"
          ;;
          3)service v2ray stop
            genId
            if [  -f "/etc/v2ray/config.json" ]; then
                read -p  "已帮您随机产生一个uuid:
                $id，
                满意吗？（输入y表示不满意再生成一个，按其他键表示接受）" answer
                while [[ "$answer" = "y" ]]; do
                    genId
                    read -p  "uuid:$id，满意吗？（不满意输入y,按其他键表示接受）" answer
                done
                rm -f config.json
                curl -O https://raw.githubusercontent.com/JeannieStudio/jeannie/master/config.json
                sed -i "s/"b831381d-6324-4d53-ad4f-8cda48b30811"/$id/g" config.json
                \cp -rf config.json /etc/v2ray/config.json
                echo -e  "${GREEN}恭喜你，UUID修改成功${NO_COLOR}"
                sed -i "/UUID/c UUID:        $id" /etc/motd
            else
                echo -e  "${RED}很遗憾，v2ray配置文件不存在${NO_COLOR}"
            fi
            service v2ray start
          ;;
          4)caddy -service stop
            echo -e  "${GREEN}caddy服务停止${NO_COLOR}"
          ;;
          5)caddy -service restart
            echo -e  "${GREEN}caddy服务启动${NO_COLOR}"
          ;;
          0) exit
          ;;
          *)echo -e "${RED}输入错误！！！${NO_COLOR}"
            exit
          ;;
      esac
      fi
      #=========安装的v2ray+nginx+tls一键脚本==============================
      if [ -e "/usr/sbin/nginx" -a -e "/usr/bin/v2ray/v2ray" ]; then
            echo -e "
      $FUCHSIA===================================================
      ${GREEN}系统检测到您目前安装的是v2ray+nginx+tls一键脚本
      $FUCHSIA===================================================
      ${GREEN}1. 停止v2ray     ${GREEN}2. 重启v2ray
      $FUCHSIA===================================================
      ${GREEN}3. 修改UUID      ${GREEN}4. 停止nginx
      $FUCHSIA===================================================
      ${GREEN}5. 重启nginx     ${GREEN}0. 退出
      $FUCHSIA===================================================${NO_COLOR}"
      read -p "请输入您要执行的操作的数字:" aNum
      case $aNum in
          1)service v2ray stop
            echo -e  "${GREEN}v2ray服务停止${NO_COLOR}"
          ;;
          2)service v2ray restart
            echo -e  "${GREEN}v2ray服务启动${NO_COLOR}"
          ;;
          3)service v2ray stop
            genId
            if [  -f "/etc/v2ray/config.json" ]; then
                read -p  "已帮您随机产生一个uuid:
                $id，
                满意吗？（输入y表示不满意再生成一个，按其他键表示接受）" answer
                while [[ "$answer" = "y" ]]; do
                    genId
                    read -p  "uuid:$id，满意吗？（不满意输入y,按其他键表示接受）" answer
                done
                rm -f config.json
                curl -O https://raw.githubusercontent.com/JeannieStudio/jeannie/master/config.json
                sed -i "s/"b831381d-6324-4d53-ad4f-8cda48b30811"/$id/g" config.json
                \cp -rf config.json /etc/v2ray/config.json
                echo -e  "${GREEN}恭喜你，UUID修改成功${NO_COLOR}"
                sed -i "/UUID/c UUID:        $id" /etc/motd
            else
                echo -e  "${RED}很遗憾，v2ray配置文件不存在${NO_COLOR}"
            fi
            service v2ray start
          ;;
          4)nginx -s stop
            echo -e  "${GREEN}nginx服务停止${NO_COLOR}"
          ;;
          5)nginx
            echo -e  "${GREEN}nginx服务启动${NO_COLOR}"
          ;;
          0) exit
          ;;
          *)echo -e "${RED}输入错误！！！${NO_COLOR}"
            exit
          ;;
      esac
      fi
      #=========安装的ssr+caddy+tls一键脚本==============================
      if [ -e "/usr/local/bin/caddy" -a -d "/usr/local/shadowsocks" ]; then
            echo -e "
      $FUCHSIA===================================================
      ${GREEN}系统检测到您目前安装的是v2ray+caddy+tls一键脚本
      $FUCHSIA===================================================
      ${GREEN}1. 停止ssr      ${GREEN}2. 重启ssr
      $FUCHSIA===================================================
      ${GREEN}3. 修改密码       ${GREEN}4. 停止caddy
      $FUCHSIA===================================================
      ${GREEN}5. 重启caddy      ${GREEN}0. 退出
      $FUCHSIA===================================================${NO_COLOR}"
      read -p "请输入您要执行的操作的数字:" aNum
      case $aNum in
          1)/etc/init.d/shadowsocks-r stop
            echo -e  "${GREEN}ssr服务停止${NO_COLOR}"
          ;;
          2)/etc/init.d/shadowsocks-r restart
            echo -e  "${GREEN}ssr服务启动${NO_COLOR}"
          ;;
          3)/etc/init.d/shadowsocks-r stop
            read -p "请输入您要修改的密码：" password
            sed -i "7c \"password\":\"$password\"," /etc/shadowsocks-r/config.json
            /etc/init.d/shadowsocks-r start
            sed -i "7c /密码:        \"$password\"" /etc/motd
          ;;
          4)caddy -service stop
            echo -e  "${GREEN}caddy服务停止${NO_COLOR}"
          ;;
          5)caddy -service restart
            echo -e  "${GREEN}caddy服务启动${NO_COLOR}"
          ;;
          0) exit
          ;;
          *)echo -e "${RED}输入错误！！！${NO_COLOR}"
            exit
          ;;
      esac
      fi
fi
}
mgr
