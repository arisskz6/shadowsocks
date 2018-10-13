#!/bin/bash
# a Script to redeploy my hexo blog
# History:
# 2018/08/03 v0.0.2 修正了错误，重构代码，使其模块化，便于后续维护修改
# 2018/10/13 修复了不能正确检测软件安装与否的问题
# By arisskz6  arisstz6@gmail.com

# 获取用户输入的yes或no
get_yesno()
{
	local yn
	local result=0
	read -p "请选择是(y/Y)或否(n/N): " yn
	while [ $yn != "y" ] && [ $yn != "Y" ] && [ $yn != "n" ] && [ $yn != "N" ]
	do
			read -p "对不起，请选择是(y/Y)或否(n/N): " yn
	done
	if [ $yn == "y" ] || [ $yn == "Y" ]; then
			result=0
	else
			result=1
	fi	
	return $result
}
# 配置git环境
git_config()
{
		local user_name=$(git config --get user.name)
		local user_email=$(git config --get user.email)
		if [ "$user_name" != "arisskz6" ]; then
				git config --global user.name "arisskz6"
		fi
		if [ "$user_email" != "arisstz6@gmail.com" ]; then
				git config --global user.email "arisstz6@gmail.com"
		fi

}
# 生成ssh密钥对
make_sshkey()
{
	ssh-keygen -t rsa -b 4096 -C "arisstz6@gmail.com"
	eval "$(ssh-agent -s)" #启动ssh-agent后台程序
	ssh-add ~/.ssh/id_rsa #添加ssh密钥到ssh-agent
}

sshkey_config()
{
if [ -e ~/.ssh/id_rsa ] && [ -e ~/.ssh/id_rsa.pub ]; then
		local exist=0
else
		local exist=1
fi
if [ $exist -ne 0 ]; then
		make_sshkey
fi
}

package_exist()
{
		if pacman -Q $1 > /dev/null 2>&1; then
				return 0;
		else
				return 1;
		fi
}

packages_install()
{
		local packages=(git openssh nodejs npm)
		for i in ${packages[@]}
		do
				if package_exist "$i"; then
						echo "${i}已安装."
				else
						echo "正在安装${i}..."
						sudo pacman -S $i --noconfirm
				fi
		done
}


echo "这是一个专用(懒人)脚本，用来在换电脑或重装系统后重新配置hexo博客编辑环境"
echo
echo "请在您博客想放置的目录下执行此脚本，是否继续？"
if ! get_yesno; then
		echo "您选择了不继续执行，正在退出..."
		echo
		exit 1
fi
# 安装需要的软件
packages_install
sleep 3
# 配置git
echo
echo "正在配置Git..."
sleep 1
git_config

# 配置ssh key
echo
echo "正在配置ssh key..."
echo
sleep 2
sshkey_config
echo
cat ~/.ssh/id_rsa.pub
echo
sleep 3
echo "请复制上面的ssh公钥添加到Github上"
echo "是否已经将本机的ssh公钥添加到Github上?"
if ! get_yesno; then
	echo "您没有将本机ssh公钥添加到Github, 无法继续执行，退出中..."
	exit 1
fi
sleep 2


# 测试ssh到Github是否已连通
echo
echo "正在测试ssh到Github是否已连通..."
echo
ssh -T git@github.com

# 克隆博客仓库到本地
sleep 2
echo
echo "正在克隆博客仓库到本地..."
sleep 1
if [ ! -d arisskz6.github.io ]; then
	git clone git@github.com:arisskz6/arisskz6.github.io.git
else
		echo "arisskz6.github.io.git目录已存在，是否覆盖？"
		if ! get_yesno; then
				rm -rf arisskz6.github.io 
				git clone git@github.com:arisskz6/arisskz6.github.io.git
		fi
fi

# 配置nodejs
echo
echo "正在配置nodejs..."
echo
sleep 2
npm config set prefix ~/.npm
export NPM_HOME="$HOME/.npm/bin"
echo $PATH | grep "$NPM_HOME"
if !(echo $PATH | grep "$NPM_HOME"); then
		echo export PATH="$NPM_HOME:$PATH" >> ~/.bashrc
		echo export PATH="$NPM_HOME:$PATH" >> ~/.zshrc
fi
# 安装hexo
echo
echo "正在安装hexo..."
echo
sleep 1
npm install hexo-cli -g
cd arisskz6.github.io
git config credential.helper store #在本地保存用户名和密码，避免每次提交都输入密码
npm install
npm install hexo-deployer-git --save

echo 
echo "-------------------------------------"
echo "- hexo博客编辑环境部署完毕, enjoy it! -"
echo "-------------------------------------"
echo 
sleep 3
