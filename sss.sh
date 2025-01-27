#!/bin/bash
#========================================================
#   系统要求: CentOS 7+ / Debian 8+ / Ubuntu 16+ 
#   依赖: Docker、Docker Compose、Python3
#   脚本功能: ServerStatus 监控安装脚本
#   项目地址: https://github.com/lidalao/ServerStatus
#========================================================

GITHUB_RAW_URL="https://raw.githubusercontent.com/jscntw/ServerStatus/master"
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

export PATH=$PATH:/usr/local/bin

# 预检查
pre_check() {
    command -v systemctl >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "不支持此系统：未找到 systemctl 命令"
        exit 1
    fi

    # 检查 root 权限
    [[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用 root 用户运行此脚本！\n" && exit 1

    # 检查 Docker 是否安装
    command -v docker >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo -e "${red}错误: ${plain} 未找到 Docker，请先安装 Docker！"
        exit 1
    fi

    # 检查 Docker Compose 是否安装
    command -v docker-compose >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo -e "${red}错误: ${plain} 未找到 Docker Compose，请先安装 Docker Compose！"
        exit 1
    fi
}

# 修改 Bot 配置
modify_bot_config() {
    if [[ $# -lt 2 ]]; then
        echo -e "${red}参数错误，未能正确提供 TG Bot 信息，请手动修改 compose.yaml 中的 bot 信息${plain}"
        exit 1
    fi

    tg_chat_id=$1
    tg_bot_token=$2

    if [[ ! -f compose.yaml ]]; then
        echo -e "${red}错误: ${plain} 未找到 compose.yaml 文件，请确保脚本目录正确！"
        exit 1
    fi

    sed -i "s/tg_chat_id/${tg_chat_id}/" compose.yaml
    sed -i "s/tg_bot_token/${tg_bot_token}/" compose.yaml
}

# 启动面板
install_dashboard() {
    echo -e "> 启动面板"
    
    # 修改 bot 配置
    modify_bot_config "$@"

    # 启动面板
    echo -e "> 启动 ServerStatus"
    docker-compose up -d ServerStatus >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "${red}错误: ${plain} 启动 ServerStatus 失败，请检查 Docker Compose 配置！"
        exit 1
    fi

    echo -e "${green}ServerStatus 已成功启动！${plain}"
}

# 节点管理
nodes_mgr() {
    if [[ ! -f _sss.py ]]; then
        echo -e "${red}错误: ${plain} 未找到 _sss.py 文件，请确保脚本目录正确！"
        exit 1
    fi

    python3 _sss.py
}

# 执行脚本
pre_check
install_dashboard "$@"
nodes_mgr