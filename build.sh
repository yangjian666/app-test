#!/bin/bash
#
# auto deploy will call this script after `svn up && mv to target`
#

export LANG=en_US.UTF-8

declare -r __PWD__=$(pwd)
declare -r __USER__=$(whoami)
declare -r VERSION=`date "+%Y%m%d%H%M%S"`

NAME=$1
echo $PATH
mv etc/config.${NAME}.yaml etc/config.yaml
make release

echo "start build!!!"

exit 0