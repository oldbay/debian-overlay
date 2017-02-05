# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pbuilder/Attic/pbuilder-0.122.ebuild,v 1.4 2010/09/03 14:09:50 flameeyes dead $

EAPI=5

DESCRIPTION="tool that converts source archives into Debian package source"
HOMEPAGE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

#S=${WORKDIR}

DEPEND="dev-util/debhelper
    dev-util/dh-python"

src_install() {

    exeinto /usr/bin
    exeopts -m755
    doexe ${S}/dh_make
    doexe ${S}/dh_makefont

    insinto /usr/share/debhelper/dh_make
    doins -r ${S}/lib/*
}