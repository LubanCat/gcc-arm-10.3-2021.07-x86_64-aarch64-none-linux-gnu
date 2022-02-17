#!/bin/bash

# command to install toolchain in the "dirname" which you Specified.
# source ./env_install_toolchain.sh dirname
INSTALL_TARGET_DIR=
toolchain_cross=`pwd`
toolchain_cross=$(basename ${toolchain_cross})
if [ -n "$1" ]; then
	if [ -d "$1" ]; then
		INSTALL_TARGET_DIR=$1
		build_toolchain_path="${INSTALL_TARGET_DIR}/$toolchain_cross/bin"
	else
		echo "error: not found dir $1"
		return 1
	fi
else
	build_toolchain_path="${PWD}/bin"
fi

echo "Install toolchain for user id:"
echo "    root (need root permission): [0]"
echo "    current user (recommend): [1]"
read -p "enter select: " selectopt
case $selectopt in
        0)
                if [ -n "$INSTALL_TARGET_DIR" ]; then
                        sudo cp -rfa $PWD $INSTALL_TARGET_DIR
                fi
                sudo echo "export PATH=$build_toolchain_path/:\$PATH" >> /etc/profile
                source /etc/profile
                ;;
        1)
                if [ -n "$INSTALL_TARGET_DIR" ]; then
                        cp -rfa $PWD $INSTALL_TARGET_DIR
                fi
                cmdsed="sed -i '/^export PATH.*${toolchain_cross}\/bin/d' \$HOME\/.bashrc"
                eval $cmdsed
                echo "export PATH=$build_toolchain_path:\$PATH" >> $HOME/.bashrc
                source $HOME/.bashrc
                ;;
        *)
                echo "Please check input."
                ;;
esac
