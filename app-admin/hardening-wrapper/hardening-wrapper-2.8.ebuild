# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Makefile for enabling compiler flags for security hardening"
HOMEPAGE=""
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}+nmu2.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-util/debhelper-9
        >=dev-lang/perl-5.10"
RDEPEND=$DEPEND

S=${WORKDIR}/${PN}-${PV}+nmu2

src_build() {
    emake
}

src_install() {
    exeinto /usr/bin
    exeopts -m755
    doexe ${S}/build-tree/hardening-check
    doexe ${S}/build-tree/hardened-cc
    doexe ${S}/build-tree/hardened-c++
    doexe ${S}/build-tree/hardened-ld

    exeinto /usr/share/hardening-includes
    exeopts -m755
    doexe ${S}/build-tree/hardening.make
}