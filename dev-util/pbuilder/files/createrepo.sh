#! /bin/bash

# codename
if [ -n "$1" ];then
    codename=$1
else
    codename="pbuilder"
fi
# repo
if [ -n "$2" ];then
    repo=$2
else
    #repo="/home/ftp/vega"
    repo="/var/cache/pbuilder/tmprepo"
fi
# tmp_repo
if [ -n "$3" ];then
    result_dir=$3
else
    result_dir="/var/cache/pbuilder/result"
fi


ch_files=`ls ${result_dir}/*.changes`


for chfile in $ch_files;do
    echo ${chfile}
    reprepro -b ${repo} \
             --ignore=wrongdistribution \
             --ignore=missingfile \
             include ${codename} ${chfile}
done
