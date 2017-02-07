#!/bin/bash

# repo
if [ -n "$1" ];then
    repo=$1
else
    repo="."
fi

all_pkgs=`find ${repo}/pool -type f -name *.deb`
all_srcs=`find ${repo}/pool -type f -name *.dsc`


orbhans(){
    for pkg_path in $all_select
    do
        pkg=`echo $pkg_path| awk -F "/" '{print $NF}'`
        type=`echo $pkg_path| awk -F "." '{print $NF}'`
        name=`echo $pkg| awk -F "_" '{print $1}'`
        ver=`echo $pkg| awk -F "_" '{print $2}'`
        if [ "$type" == "dsc" ];then
            ver=${ver%.*}
        fi
        echo $ver| grep \: >/dev/null
        if [ $? -eq 0 ];then
            ver=`echo $ver|awk -F ":" '{print $2}'`
        fi

        reprepro -b ${repo} ls $name|awk -F "|" '{print $2}'|grep $ver >/dev/null
        if [ $? -ne 0 ];then
            echo ""
            echo "PACKAGE: $name VER: $ver TYPE: $type"
            echo "-----Reprepro INFO-----"
            reprepro -b ${repo} ls $name
            echo -n "Remove ${pkg_path} (y/n)? n"
            read sel
            if [ "$sel" == "y" ]||[ "$sel" == "Y" ]||[ "$sel" == "yes" ]||[ "$sel" == "Yes" ]||[ "$sel" == "YES" ];then
                if [ "$type" == "deb" ];then
                    echo "REMOVE: $pkg_path"
                    rm $pkg_path
                elif [ "$type" == "dsc" ];then
                    pkg_filelist=`cat $pkg_path|sed -n '/Checksums-Sha1:/,/Checksums-Sha256:/p'|awk '{print $3}'|sed '/./!d'`
                    pkg_dir=$(dirname "$pkg_path")

                    echo "REMOVE: $pkg_path"
                    rm $pkg_path
                    for pkg_file in $pkg_filelist
                    do
                        # orig file analis ???
                        echo "REMOVE: ${pkg_dir}/${pkg_file}"
                        rm ${pkg_dir}/${pkg_file}
                    done
                fi
            fi
        fi
    done
}


echo ""
echo "ORBHANS DEB"
echo "-----------"
all_select=$all_pkgs
orbhans

echo ""
echo "ORBHANS DSC"
echo "-----------"
all_select=$all_srcs
orbhans

echo ""
echo "DUBL"
echo "----"
for deb_path in $all_pkgs
do
    deb=`echo $deb_path| awk -F "/" '{print $NF}'`
    name=`echo $deb| awk -F "_" '{print $1}'`
    ver=`echo $deb| awk -F "_" '{print $2}'`

    let dubl=`reprepro -b ${repo} ls $name|awk -F "|" '{print $2}'|grep $ver |wc -l`
    if [ $dubl -gt 1 ];then
        echo ""
        echo "PACKAGE: $name VER: $ver"i
        reprepro -b ${repo} ls $name
    fi
done
