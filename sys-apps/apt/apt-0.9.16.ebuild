# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit multilib

DESCRIPTION="Package manager known from the Debian Project"
HOMEPAGE="http://packages.debian.org/sid/apt"
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="" # ~amd64 ~x86
IUSE=""

DEPEND="sys-devel/libtool
        sys-devel/gnuconfig"
RDEPEND="app-crypt/debian-archive-keyring"

S=${WORKDIR}/upstream.git

src_prepare() {
    # Replace dead symlinks
    for i in config.{guess,sub} ; do
	#rm buildlib/${i} || die
	ln -s /usr/share/gnuconfig/${i} buildlib/${i} || die
    done

    # Prevent any doc compliation (due to current errors) TODO!
    echo -e '%:\n\ttouch $@' > doc/makefile
}

src_install() {
    # Imitate Debian .dir file handling
    for i in debian/*.dirs; do
	sed "s|^|${D}/|" < "${i}" | xargs mkdir -p
    done

    # Imitate Debian .install file handling
    for i in debian/*.install{,.in}; do
	while read line ; do
	    if [[ "${line}" == *' '* ]]; then
		line="$(sed "s|/lib/@DEB_HOST_MULTIARCH@/|/$(get_libdir)/|" <<<"${line}")"
		mkdir -p "$(sed "s|^.* |${D}/|" <<<"${line}"))"
		install -v -D $(sed "s| | ${D}/|" <<<"${line}")
	    else
		mkdir -p $(dirname ${line})  # potentially several directories
		cp --parents -v ${line} "${D}"/
	    fi
	done < "${i}"
    done

    #BUG libapt-private.so
    exeinto /usr/lib64
    exeopts -m755
    doexe ${S}/bin/libapt-private.so*

    insinto /etc/apt
    doins ${FILESDIR}/sources.list

    insinto /var/lib/dpkg
    doins ${FILESDIR}/status
}