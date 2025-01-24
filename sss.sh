#!/bin/bash
#========================================================
#   System Required: CentOS 7+ / Debian 8+ / Ubuntu 16+ /
#     Arch 未测试
#   Description: Server Status 监控安装脚本
#   Github: https://github.com/lidalao/ServerStatus
#========================================================

GITHUB_RAW_URL="https://raw.githubusercontent.com/jscntw/ServerStatus/master"
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
export PATH=$PATH:/usr/local/bin

pre_check() {
    command -v systemctl >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "不支持此系统：未找到 systemctl 命令"
        exit 1
    fi
    # check root
    [[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1
}

modify_bot_config(){
    if [[ $# < 2 ]]; then
        echo -e "${red}参数错误，未能正确提供tg bot信息，请手动修改compose.yaml中的bot信息 ${plain}"
        exit 1
    fi
    tg_chat_id=$1
    tg_bot_token=$2
    sed -i "s/tg_chat_id/${tg_chat_id}/" compose.yaml
    sed -i "s/tg_bot_token/${tg_bot_token}/" compose.yaml
}

install_dashboard(){
    echo -e "> 启动面板"
    # 修改 bot 配置
    modify_bot_config "$@"
    # 启动面板（假设 Docker 已经安装并配置好）
    (docker-compose up -d) >/dev/null 2>&1
}

nodes_mgr(){
    python3 _sss.py
}

pre_check
install_dashboard "$@"
nodes_mgr
