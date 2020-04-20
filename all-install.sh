#! /bin/bash
#######color code########
RED="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
workspace(){
  cd /root
}
init_release(){
  if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
  if [[ $release = "ubuntu" || $release = "debian" ]]; then
    PM='apt'
  elif [[ $release = "centos" ]]; then
    PM='yum'
  else
    exit 1
  fi
  # PM='apt'
}
check_status(){
  if [ -e "/usr/local/bin/caddy" -o -d "/usr/local/shadowsocks" -o -e "/etc/systemd/system/v2ray.service" -o -e "/usr/bin/v2ray/v2ray" -o -e "/usr/sbin/nginx"  -o -e "/usr/local/bin/trojan" -o -e "/usr/local/bin/caddy_old" -o -e "/etc/systemd/system/trojan.service" -o -e "/etc/systemd/system/caddy.service" ]; then
	    Flag="YES"
	    echo -e "${RED}检测到您已安装过其他环境，请先卸载再重装.${NO_COLOR}"
	    exit
	else
	   Flag="NO"
  fi
}
uninstall_caddy(){
  #======================卸载caddy===============================
      if [ -e "/usr/local/bin/caddy" ]; then
        caddy -service stop
        caddy -service uninstall
        rm -f /usr/local/bin/caddy
        rm -f /usr/local/bin/caddy_old
        rm -f /etc/systemd/system/caddy.service
        rm -rf /etc/caddy
        rm -rf /etc/ssl/caddy
      fi
}
uninstall_nginx(){
  #======================卸载nginx===============================
      if [ -f "/usr/sbin/nginx" ]; then
          nginx -s stop
          if [ $PM = 'yum' ]; then
            yum remove -y nginx
          elif [ $PM = 'apt' ]; then
            apt autoremove -y nginx
          fi
      fi
}
uninstall_trojan(){
  #======================卸载trojan===============================
      if [ -f "/usr/local/bin/trojan" ]; then
          systemctl stop trojan
          systemctl disable trojan
          rm -f /usr/local/bin/trojan
          rm -f /etc/systemd/system/trojan.service
          rm -rf /usr/local/etc/trojan
      fi
}
uninstall_v2ray(){
   #======================卸载v2ray================================
      if [ -e "/usr/bin/v2ray/v2ray" ]; then
         service v2ray stop
         rm -rf /usr/bin/v2ray
         rm -f /etc/systemd/system/v2ray.service
      fi
}
uninstall_ssr(){
  #======================卸载ssr================================
      if [ -d "/usr/local/shadowsocks" ]; then
          /etc/shadowsocks-r/shadowsocks-all.sh uninstall 2>&1 | tee /etc/ssr_uninstall.log
          grep "ShadowsocksR uninstall success" /etc/ssr_uninstall.log >/dev/null
          if [ $? -eq 0 ]; then
              myflag="YES"
              sleep 3
	            rm -rf /etc/shadowsocks-r
            else
              myflag="NO"
          fi
      fi
}
uninstall_web(){
  #======================删除伪装网站==============================
      if [ -d "/var/www" ]; then
        rm -rf /var/www
      fi
}
uninstall_timetast(){
  #======================删除定时任务==============================
      crontab -r
      rm -f /etc/RST.sh
}
uninstall(){
  init_release
  read -p "您确定要卸载吗? [y/n]?" myanswer
  if [ "$myanswer" = "y" ]; then
    if [ -d "/usr/local/shadowsocks" ]; then
        uninstall_ssr
        if [ "$myflag" = "YES" ]; then
              uninstall_caddy
              uninstall_nginx
              uninstall_trojan
              uninstall_v2ray
              uninstall_web
              uninstall_timetast
              echo -e "${GREEN}卸载成功！！${NO_COLOR}"
        else
              echo -e "${RED}ssr卸载失败${NO_COLOR}"
              exit
        fi
    else
        uninstall_caddy
        uninstall_nginx
        uninstall_trojan
        uninstall_v2ray
        uninstall_web
        uninstall_timetast
        echo -e "${GREEN}卸载成功！！${NO_COLOR}"
    fi

  else
        echo -e "${RED}卸载失败!!!!${NO_COLOR}"
  fi
    }
install(){
  workspace
  echo -e "
$FUCHSIA===================================================
${GREEN}     trojan、v2ray、ssr六合一脚本
$FUCHSIA===================================================
${GREEN}1. 安装trojan+tls+nginx
$FUCHSIA===================================================
${GREEN}2. 安装trojan+tls+caddy
$FUCHSIA===================================================
${GREEN}3. 安装v2ray+tls+nginx
$FUCHSIA===================================================
${GREEN}4. 安装v2ray+tls+caddy
$FUCHSIA===================================================
${GREEN}5. 安装ssr+tls+caddy
$FUCHSIA===================================================
${GREEN}6. 运行BBR安装脚本
$FUCHSIA===================================================
${GREEN}7. 卸载已安装的服务端
$FUCHSIA===================================================
${GREEN}0. 退出${NO_COLOR}"
read -p "请输入您要执行的操作的数字:" aNum
case $aNum in
    1)check_status
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/6in1/master/trojan-nginx-tls-b.sh)"
    ;;
    2)check_status
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/6in1/master/trojan-caddy-tls-b.sh)"
      ;;
    3)check_status
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/6in1/master/v2ary-nginx-tls-b.sh)"
    ;;
    4)check_status
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/6in1/master/v2ary-caddy-tls-b.sh)"
    ;;
    5)check_status
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/6in1/master/ssr-caddy-tls-b.sh)"
    ;;
    6)check_status
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Shuazijun/Linux-NetSpeed/master/tcp.sh)"
    ;;
    7)uninstall
    ;;
    0)exit
    ;;
    *)echo -e "${RED}输入错误！！！${NO_COLOR}"
      exit
    ;;
esac
}
main(){
  install
}
main
