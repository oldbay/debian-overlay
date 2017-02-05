#! /bin/bash

dir_repo="."
dir_copy="/home/ftp/packages"
arhs="amd64 all"

reprepro listfilter $1 '$PackageType (== deb)' >/tmp/list_pkg


while read line
do
    name=`echo $line|awk '{print $2}'`
    ver=`echo $line|awk '{print $3}'i`
    echo $ver| grep \: >/dev/null
    if [ $? -eq 0 ];then
        ver=`echo $ver|awk -F ":" '{print $2}'`
    fi
    echo "$name $ver"
    for arh in $arhs
    do
        repo_path=`find $dir_repo -type f -name ${name}_${ver}_${arh}.deb`
        if [ "$repo_path" != "" ];then
            echo $repo_path
            cp $repo_path $dir_copy
        fi
    done
done < "/tmp/list_pkg"