#!/bin/bash

# mask
if [ -n "$1" ];then
    mask=$1
else
    echo "Please insert mask (debian|orig)"
    exit 1
fi

# find string
if [ -n "$2" ];then
    find_string=$2
else
    echo "Please insert find string"
    exit 1
fi

# repo
if [ -n "$3" ];then
    work_dir=$3
else
    work_dir="."
fi

files=`find ${work_dir} -type f -name *.${mask}.tar.*`
for testfile in $files
do
    out=`tar -tf ${testfile}|grep ${find_string}`
    if [ "$out" != "" ];then
        echo
        echo $testfile
        echo "----------------"
        echo $out
    fi
done

#find . -type f -name *.debian.tar.* -exec tar -tvf {} \;
