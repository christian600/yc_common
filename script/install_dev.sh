#!/bin/bash
###
 # @File: 
 # @Description: 
 # @Author: WK
 # @Version: 
 # @Date: 2023-05-09 14:50:04
 # @Change: 
### 
# 将asf安装部署到开发环境
# 调用方式
#   ./install.sh include_dir lib_dir
#   include_dir: 头文件安装目录
#   lib_dir: .so/.a 等库文件安装目录
#
#   TO DO: 用CPack打包

CP=`which cp`
PACKAGE_NAME="yc_common"

error_out()
{
        echo "$@"
        exit 1
}

if [ $# != 2 ]; then
	echo ""
	echo "USAGE: $0 include_file_dire lib_file_dir"
	echo " e.g.: $0 /usr/include /usr/lib"
	error_out ""
fi

INCLUDE_TARGET=`cd $1 ; pwd`
LIB_TARGET=`cd $2 ; pwd`


#01 install include files
pushd include
$CP -R ./ $INCLUDE_TARGET || error_out "install include files failed!"

popd

#02 install lib files
pushd libs
$CP -R ./ $LIB_TARGET || error_out "install lib files failed!"
popd

printf "\n"
printf "================================\n"
printf "install yc_common sucessfully!\n" 
