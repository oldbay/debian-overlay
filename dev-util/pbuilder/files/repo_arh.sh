#! /bin/bash

# repo
if [ -n "$1" ]&&[ -n "$2" ];then
    repo_path=$1
    repo_name=$2
else
    repo_path="/home/ftp"
    repo_name="vega"
fi

find ${repo_path}/${repo_name} -type d -exec chmod 2775 {} \;
find ${repo_path}/${repo_name} -type f -exec chmod 0664 {} \;

local_dir=$PWD
cd ${repo_path}/${repo_name}
tar cvzpf ${repo_path}/${repo_name}.tar.gz ./
cd $local_dir
exit 0