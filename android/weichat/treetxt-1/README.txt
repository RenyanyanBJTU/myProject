
*各个文件夹命名解释：

shellscript：存放运行的脚本(mergesh.sh 使用bash命令运行)
stat* ： 存放每次运行脚本后生成的中间txt文件，包含目录树等的txt
patchdir：存放diff比较生成的patch文件
mergepatch : 存放修改后的patch文件


*文件或者文件夹后面的数字解释：

0 ： 未安装微信之前系统的初始状态
1 ： 安装后但未登录之前的系统状态
2 ： 登陆之后但不进行任何操作的系统状态
3 ： 只修改个人信息（或者配置信息？）后的系统状态
4 ： 进行聊天后的系统状态

【注 ： 有改动再更新此文档】
