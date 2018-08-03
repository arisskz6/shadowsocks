#!/bin/bash -e
# a Script to redeploy my hexo blog
# History:
# 2018/07/15 v0.1
# By arisskz6  arisstz6@gmail.com

read -p "请在您博客想放置的目录下执行此脚本，是否继续？y/N" dir_yn
if [ ${dir_yn} != "y" ] && [ ${dir_yn} != "Y" ]; then
		echo "没有选择是"
		exit
fi
# 安装nodejs 和 npm
#pacman -Q nodejs
#if [ $? -eq 0 ]; then
#		node_exist=1
#else
#		node_exist=0
#fi
#pacman -Q npm
#if [ $? -eq 0 ]; then
#		npm_exist=1
#else
#		npm_exist=0
#fi
#
#if [ ${node_exist} -eq 0 ]; then
#	   	sudo pacman -Sy nodejs
#fi

#if [ ${npm_exist} -eq 1 ]; then
#	   	sudo pacman -Sy npm
#fi

check_noexist()
{
	pacman -Q $1
	if [ $? -eq 0 ];then
			noexist=1;
	else
			noexist=0;
	fi

	return $noexist
}

if $(check_noexist nodejs); then
		sudo pacman -Sy nodejs --noconfirm
fi

if $(check_noexist npm); then
		sudo pacman -Sy npm --noconfirm
fi

# 配置hexo环境
npm config set prefix ~/.npm
export PATH="$PATH:$HOME/.npm/bin"
echo export PATH="$PATH:$HOME/.npm/bin" >> ~/.zshrc
echo export PATH="$PATH:$HOME/.npm/bin" >> ~/.bashrc

# 配置git环境
#git config --global user.name "arisskz6"
#git config --global user.email arisstz6@gmail.com

mksshkey()
{
	ssh-keygen -t rsa -b 4096 -C "arisstz6@gmail.com"
	eval "$(ssh-agent -s)" #启动ssh-agent后台程序
	ssh-add ~/.ssh/id_rsa #添加ssh密钥到ssh-agent
}
echo "这是一个专用(懒人)脚本，用来在换电脑或重装系统后重新配置hexo博客编写环境"
echo "在进一步操作之前，请确保完成了以下工作:"

# 设置flag, 满足条件flag被变为1，后面会检测flag的值，为1则程序继续执行，否则退出
flag1=0
if [ -e ~/.ssh/id_rsa ] && [ -e ~/.ssh/id_rsa.pub ]; then
		flag1=1
fi


if [ "${flag1}" -eq 0 ]; then
		mksshkey
fi

echo "请将你的ssh公钥添加到Github上"
read -p "是否已经将本机的ssh公钥添加到Github上? y/N" yn
if [ "$yn" != "y" ] && [ "$yn" != "Y" ]; then
	echo "您没有将本机ssh公钥添加到Github, 无法继续执行，退出中..."
	exit 1
fi


# 测试ssh到Github是否已连通
ssh -T git@github.com

# 克隆博客仓库到本地
git clone git@github.com:arisskz6/arisskz6.github.io.git

# 安装hexo
npm install hexo-cli -g
cd arisskz6.github.io
npm install
npm install hexo-deployer-git --save

echo 
echo "-------------------------------------"
echo "- hexo博客编辑环境配置完毕，enjoy it! -"
echo "-------------------------------------"
echo 
