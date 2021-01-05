# -*-coding: utf-8-*-
from fabric import Connection

class RemoteModule():
    # 初始化服务器连接信息
    def __init__(self, ip, port, user, passwd):
        '''ip即服务器ip地址，port是该服务器的ssh端口，user即登陆服务器的用户身份（通常是root），passwd是该用户的密码'''
        self.ip     = ip 
        self.port   = port     
        self.user   = user      
        self.passwd = passwd
        
    # 上传文件函数
    def upload_file(self, file_with_path, remote_path):
        '''file_with_path和remote_path分别代表本地文件的完整路径和需要上传到的远程目录，必须使用绝对路径'''
        try:
            # 创建SSH连接实例，连接到远程服务器
            c = Connection(self.ip, user=self.user, port=self.port, connect_kwargs={"password": self.passwd})
            # 调用put方法上传本地文件到远程目录
            c.put(file_with_path, remote_path)
            # 关闭连接实例
            c.close()
        except:
            # 打印报错信息
            print(f"{file_with_path} send failed") 
        
#        return status_code, response.text
    
    # 下载文件函数
    def download_file(self, remote_file_with_path, local_path):
        '''remote_file_with_path和local_path分别代表远程文件的完整路径和需要下载到的本地路径（不能只是目录，必须加文件名），避免产生麻烦，尽量使用绝对路径'''
        try:
            # 创建SSH连接实例，连接到远程服务器
            c = Connection(self.ip, user=self.user, port=self.port, connect_kwargs={"password": self.passwd})
            # 调用get方法将远程服务器上的文件下载到本地
            c.get(remote_file_with_path, local_path)
            # 关闭连接实例
            c.close()
        except:
            print(f"download file {remote_file_with_path} failed");

    # 远程执行命令函数
    def exec_cmd(self, cmd):
        '''cmd是要执行的命令，是一个字符串，例如 'ls -l' '''
        # 创建SSH连接实例，连接到远程服务器
        c = Connection(self.ip, user=self.user, port=self.port, connect_kwargs={"password": self.passwd})
        # 在远程服务器上执行命令，将返回执行后的结果，如同在本地执行一样
        c.run(cmd)
        

if __name__ == '__main__':   
     # 初始化一个RemoteModule实例remote_test
     remote_test = RemoteModule('202.173.9.7', 3022, 'root', 'zdns@knet.cn')
     # 测试文件上传功能 
     remote_test.upload_file('/home/arisskz6/test_remotemodule.txt','/root/')
     # 测试远程命令执行功能
     remote_test.exec_cmd('ls -l') 
     # 测试文件下载功能
     remote_test.download_file('/root/data/etc/view.lua','/home/arisskz6/view.lua')
