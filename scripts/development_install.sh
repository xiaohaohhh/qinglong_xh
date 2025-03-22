#!/usr/bin/env bash

TIME() {
    [[ -z "$1" ]] && {          # 如果没有参数
        echo -ne " "            # 输出空格
    } || {
        case $1 in              # 根据第一个参数选择颜色
            r) Color="\e[31;1m";;  # 31=红色，1=加粗
            g) Color="\e[32;1m";;  # 32=绿色
            b) Color="\e[34;1m";;  # 34=蓝色
            y) Color="\e[33;1m";;  # 33=黄色
            z) Color="\e[35;1m";;  # 35=紫色
            l) Color="\e[36;1m";;  # 36=青色
        esac
        
        # 参数数量判断
        [[ $# -lt 2 ]] &&       # 如果只有1个参数
            echo -e "\e[36m\e[0m ${1}" ||  # 使用默认青色
            echo -e "\e[36m\e[0m ${Color}${2}\e[0m"  # 带指定颜色
    }
}

echo
TIME l "开始安装依赖..."
echo
TIME y "安装过程较久，请耐心等待..."
echo
sleep 2

# 设置淘宝镜像源
TIME l "配置淘宝镜像源..."
npm config set registry https://registry.npmmirror.com

# 升级npm至最新版
TIME l "升级npm到最新版本..."
npm install -g npm@latest

# 安装系统依赖
TIME l "安装系统依赖库..."
apk add --no-cache build-base g++ cairo-dev pango-dev giflib-dev \
python3 zlib-dev gcc jpeg-dev python3-dev musl-dev freetype-dev

# 安装全局npm包
TIME l "安装全局NPM依赖..."
npm install -g \
png-js \
crypto-js \
md5 \
ts-md5 \
tslib \
@types/node \
tough-cookie \
jsdom \
tunnel \
ws \
js-base64 \
got \
date-fns \
axios \
form-data \
download \
typescript \
ts-node \
qrcode-terminal \
silly-datetime

# 安装Python依赖
TIME l "安装Python依赖..."
pip3 install requests download jieba

# 特殊编译安装
TIME l "编译安装Canvas..."
if [ -d "/ql/data/scripts" ]; then
    cd /ql/data/scripts && npm install canvas --build-from-source
elif [ -d "/ql/scripts" ]; then
    cd /ql/scripts && npm install canvas --build-from-source
else
    TIME r "未找到脚本目录，跳过Canvas安装。"
fi

echo
TIME g "所有依赖安装完成！建议重启Docker容器。"
echo
TIME g "问题反馈请提交至：https://github.com/your/repo"
echo
exit 0