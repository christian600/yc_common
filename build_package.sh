#!/bin/bash


CURRENT_PATH="$( cd $(dirname $0) ; pwd -P )"
PACKAGE_NAME="yc_common"
BUILD_DIR="$CURRENT_PATH/build"
OUT_PUT_PATH="$CURRENT_PATH/output"
CP=`which cp`
RM=`which rm`
PROCESSOR=$(cat /proc/cpuinfo| grep "processor"| wc -l)

clean_output() {
    $RM -rf ${CURRENT_PATH}/output
    $RM -rf $BUILD_DIR
}

build_package() {
    mkdir -p ${BUILD_DIR}
	pushd ${BUILD_DIR}
	if [ "$1" == "debug" ]; then
		cmake -DCMAKE_INSTALL_PREFIX=${OUT_PUT_PATH} -DCMAKE_BUILD_TYPE=Debug ..
  	elif [ "$1" == "release" ];then
		cmake -DCMAKE_INSTALL_PREFIX=${OUT_PUT_PATH} -DCMAKE_BUILD_TYPE=Release ..
    elif [ "$1" == "test" ];then
		cmake -DCMAKE_INSTALL_PREFIX=${OUT_PUT_PATH} -DCMAKE_BUILD_TYPE=Debug -DBUILD_UNIT_TEST=on ..
  	fi

	make -j${PROCESSOR} && make install
	popd
}

build_tar_package() {
    if [ "$1" == "release" ];then
        TAR_PACKAGE_NAME=${PACKAGE_NAME}-release
    elif [ "$1" == "debug" ];then
        TAR_PACKAGE_NAME=${PACKAGE_NAME}-debug
    fi

    echo $TAR_PACKAGE_NAME
    pushd ${CURRENT_PATH}
        cp -a ${OUT_PUT_PATH} ${TAR_PACKAGE_NAME}
    popd

    pushd ${CURRENT_PATH}/${TAR_PACKAGE_NAME}
        mkdir script
        cp ${CURRENT_PATH}/script/install_dev.sh script/
    popd


    tar -czf ${TAR_PACKAGE_NAME}.tar.gz $TAR_PACKAGE_NAME/

    $RM ${TAR_PACKAGE_NAME} -rf
}

main() {
    clean_output
    while [ $# -ge 1 ]; do
        case $1 in
        -r | --release)
            echo "Build Release"
            build_package release
            build_tar_package release
            shift 1
            ;;
        -b | --beat)
            echo "Build Debug"
            build_package debug
            build_tar_package debug
            shift 1
            ;;
        -t | --test)
            echo "Run test"
            build_package test
            shift 1
            ;;
        ?)
            echo "unkown arg"
            exit 1
            ;;
        esac
    done
}


main "$@"
exit 0