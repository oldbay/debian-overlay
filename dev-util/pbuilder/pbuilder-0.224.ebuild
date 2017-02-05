# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pbuilder/Attic/pbuilder-0.122.ebuild,v 1.4 2010/09/03 14:09:50 flameeyes dead $

EAPI=5
inherit eutils

DESCRIPTION="personal package builder for Debian packages"

HOMEPAGE="http://packages.qa.debian.org/p/pbuilder.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

S=${WORKDIR}/${PN}

DEPEND="sys-apps/debianutils

    net-misc/wget
    dev-util/debootstrap
    app-arch/dpkg
    dev-util/reprepro
    sys-apps/fakeroot
    dev-util/cdbs
    app-admin/hardening-wrapper"

src_prepare() {
    epatch "${FILESDIR}"/doc_remove.patch
}

src_install() {

    emake DESTDIR=${D} install || die

    dodir /usr/share/debootstrap/scripts
    dosym /usr/share/debootstrap/scripts/sid /usr/share/debootstrap/scripts/smolensk

    insinto /etc
    doins ${FILESDIR}/pbuilderrc
    doins ${FILESDIR}/pb.cfg

    exeinto /var/cache/pbuilder/hooks
    exeopts -m755
    doexe ${FILESDIR}/B10CreateRepo
    doexe ${FILESDIR}/F10PbLogin
    doexe ${FILESDIR}/E10PkgsToImage
    doexe ${FILESDIR}/G10AddRepo
    doexe ${FILESDIR}/H10PreStart

    exeinto /var/cache/pbuilder/scripts
    exeopts -m755
    doexe ${FILESDIR}/apt-update
    dosym /var/cache/pbuilder/scripts/apt-update /usr/bin/pbuilder_apt-update
    doexe ${FILESDIR}/createrepo.sh
    dosym /var/cache/pbuilder/scripts/createrepo.sh /usr/bin/pbuilder_createrepo
    doexe ${FILESDIR}/copyrepo.sh
    dosym /var/cache/pbuilder/scripts/copyrepo.sh /usr/bin/pbuilder_copyrepo
    doexe ${FILESDIR}/repo_arh.sh
    dosym /var/cache/pbuilder/scripts/repo_arh.sh /usr/bin/pbuilder_repo_arh
    doexe ${FILESDIR}/pkgcopy.sh
    dosym /var/cache/pbuilder/scripts/pkgcopy.sh /usr/bin/pbuilder_pkgcopy
    doexe ${FILESDIR}/repo_test.sh
    dosym /var/cache/pbuilder/scripts/repo_test.sh /usr/bin/pbuilder_repo_test
    doexe ${FILESDIR}/pbinit
    dosym /var/cache/pbuilder/scripts/pbinit /usr/bin/pb_init
    doexe ${FILESDIR}/pbupd
    dosym /var/cache/pbuilder/scripts/pbupd /usr/bin/pb_upd
    doexe ${FILESDIR}/pbclean
    dosym /var/cache/pbuilder/scripts/pbclean /usr/bin/pb_clean
    doexe ${FILESDIR}/pblogin
    dosym /var/cache/pbuilder/scripts/pblogin /usr/bin/pb_login
    doexe ${FILESDIR}/pbrun
    dosym /var/cache/pbuilder/scripts/pbrun /usr/bin/pb_run
    doexe ${FILESDIR}/pbtc
    dosym /var/cache/pbuilder/scripts/pbtc /usr/bin/pb_tc

    insinto /usr/share/man/man1
    doman ${FILESDIR}/debuild-pbuilder.1
    doman ${FILESDIR}/pdebuild.1

    insinto /usr/share/man/man5
    doman ${FILESDIR}/pbuilderrc.5

    insinto /usr/share/man/man8
    doman ${FILESDIR}/pbuilder.8

    mkdir -p ${D}/var/cache/pbuilder/aptcache
    mkdir -p ${D}/var/cache/pbuilder/build
    mkdir -p ${D}/var/cache/pbuilder/cache
    mkdir -p ${D}/var/cache/pbuilder/result
    chmod 777 ${D}/var/cache/pbuilder/result
    mkdir -p ${D}/var/cache/pbuilder/tmprepo

    rm -rf ${D}/usr/share/bash-completion
}