# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="pbuilder using QEMU as backend"
HOMEPAGE=""
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qemu"

DEPEND="app-arch/cpio
        sys-apps/busybox
        dev-util/debhelper
        dev-libs/klibc
        dev-util/pbuilder
        qemu? ( app-emulation/qemu )"
RDEPEND=$DEPEND

#S=${WORKDIR}/${PN}

src_build() {
    emake
}

src_install() {

    exeinto /usr/bin
    exeopts -m755
    doexe ${S}/cow-shell
    doexe ${S}/cowdancer-ilistcreate
    doexe ${S}/cowdancer-ilistdump

    exeinto /usr/sbin
    exeopts -m755
    doexe ${S}/cowbuilder

    exeinto /usr/lib/cowdancer
    exeopts -m755
    doexe ${S}/libcowdancer.so

    insinto /usr/share/cowdancer/doc
    doins -r ${S}/doc/*

    insinto /usr/share/cowdancer/tests
    doins -r ${S}/tests/*

    insinto /usr/share/man/man1
    doins ${S}/cow-shell.1
    doins ${S}/cowdancer-ilistcreate.1
    doins ${S}/cowdancer-ilistdump.1

    insinto /usr/share/man/man8
    doins ${S}/cowbuilder.8

    if use qemu ; then
        exeinto /usr/sbin
        exeopts -m755
        doexe ${S}/qemubuilder

        insinto /usr/share/cowdancer/qemutool
        doins -r ${S}/qemutool/*

        insinto /usr/share/man/man8
        doins ${S}/qemubuilder.8
    fi

    #mkdir -p ${D}/var/cache/pbuilder/base.cow
}