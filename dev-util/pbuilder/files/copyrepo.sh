#! /bin/bash
# codename to
if [ -n "$1" ];then
    to_codename=$1
else
    echo "Please insert repository name!"
    exit 1
fi
# repo to
if [ -n "$2" ];then
    to_repo=$2
else
    to_repo="/media/vega"
fi
# codename from
if [ -n "$3" ];then
    from_codename=$3
else
    from_codename="pbuilder"
fi
# repo from
if [ -n "$4" ];then
    from_repo=$4
else
    from_repo="/var/cache/pbuilder/tmprepo"
fi


cr_ch(){
    #create changes
    dsc_files=`find ${from_repo}/pool | grep ".dsc$"`
    #clear no repo package
    for dsc in $dsc_files
    do
        dsc_file=`echo $dsc| awk -F '/' '{print $NF}'`
        src_name=`echo ${dsc_file::(-4)}| awk -F '_' '{print $1}'`
        src_ver=`echo ${dsc_file::(-4)}| awk -F '_' '{print $2}'`
        if [ `echo ${src_ver}| grep ":"` ];then
            src_ver=`echo ${src_ver}| awk -F ':' '{print $2}' `
        fi
        reprepro -b ${from_repo} -T dsc list ${from_codename}|grep ${src_name}|grep ${src_ver}
        if [ $? -eq 0 ];then
            dsc_dir=`echo $dsc| awk -F '/' '{for(i=1;i<NF;i++) {printf($i); if(i<NF-1) {printf("/");}}}'`
            prog_name=`echo $dsc_dir| awk -F '/' '{print $NF}'`
            if [ -f ${dsc_dir}/${prog_name}.changes ];then
                rm ${dsc_dir}/${prog_name}.changes
            fi
            changestool --create ${dsc_dir}/${prog_name}.changes adddsc ${dsc}
            #add bin file
            reprepro -b ${from_repo} -T deb listfilter ${from_codename} '$Source (== '$src_name')'|while read line
            do
                deb_name=`echo $line| awk -F ' ' '{print $2}'`
                deb_ver=`echo $line| awk -F ' ' '{print $3}'`
                if [ `echo ${deb_ver}| grep ":"` ];then
                    deb_ver=`echo ${deb_ver}| awk -F ':' '{print $2}' `
                fi
                changestool --create ${dsc_dir}/${prog_name}.changes add ${dsc_dir}/${deb_name}_${deb_ver}_*.deb
            done
            changestool ${dsc_dir}/${prog_name}.changes setdistribution unsatble
        fi
    done
}

move_rep(){
    #move repository to repo
    ch_files=`find ${from_repo}/pool | grep ".changes$"`
    for chfile in $ch_files;do
        echo ${chfile}
        reprepro -b ${to_repo} \
                --ignore=wrongdistribution \
                --ignore=missingfile \
                include ${to_codename} ${chfile}
        rm ${chfile}
    done
}

cr_ch
move_rep
if [ $? -eq 0 ];then
    apt-get update
fi
exit 0
