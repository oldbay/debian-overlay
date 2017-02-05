#! /bin/bash
# codename
if [ -n "$1" ];then
    codename=$1
else
    echo "Please insert repository name!"
    exit 1
fi
# repo
if [ -n "$2" ];then
    repo=$2
else
    repo="/home/ftp/vega"
fi
# tmp_repo
if [ -n "$3" ];then
    tmp_repo=$3
else
    tmp_repo="/var/cache/pbuilder/tmprepo"
fi


cr_ch(){
    #create changes
    dsc_files=`find ${tmp_repo}/pool | grep ".dsc$"`
    for dsc in $dsc_files
    do
        dsc_dir=`echo $dsc| awk -F '/' '{for(i=1;i<NF;i++) {printf($i); if(i<NF-1) {printf("/");}}}'`
        prog_name=`echo $dsc_dir| awk -F '/' '{print $NF}'`
        #echo $dsc
        #echo $dsc_dir
        if [ -f ${dsc_dir}/${prog_name}.changes ];then
            rm ${dsc_dir}/${prog_name}.changes
        fi
        changestool --create ${dsc_dir}/${prog_name}.changes \
                    add ${dsc} ${dsc_dir}/*.deb
        changestool ${dsc_dir}/${prog_name}.changes setdistribution unsatble
    done
}

move_rep(){
    #move repository to repo
    ch_files=`find ${tmp_repo}/pool | grep ".changes$"`
    for chfile in $ch_files;do
        echo ${chfile}
        reprepro -b ${repo} \
                --ignore=wrongdistribution \
                --ignore=missingfile \
                include ${codename} ${chfile}
    done
}

cr_ch
move_rep
if [ $? -eq 0 ];then
    apt-get update
fi
exit 0
