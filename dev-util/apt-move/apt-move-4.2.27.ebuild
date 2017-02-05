# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Maintain Debian packages in a package pool"
HOMEPAGE="https://sourceforge.net/projects/apt-move/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/dpkg
        sys-apps/apt"
RDEPEND="$DEPEND
         app-shells/dash"

S=${WORKDIR}/${PN}

src_build() {
    emake
}

src_install() {

    exeinto /usr/bin
    exeopts -m755
    doexe ${S}/apt-move

    exeinto /usr/lib/apt-move
    exeopts -m755
    doexe ${S}/fetch

    insinto /etc
    doins ${FILESDIR}/apt-move.conf

    exeinto /usr/share/apt-move
    exeopts -m755
    doexe ${S}/del1
    doexe ${S}/move3
    doexe ${S}/pkg1

    insinto /usr/share/apt-move
    doins ${S}/cmpbignum.awk
    doins ${S}/cmpversion.awk
    doins ${S}/Contents.head
    doins ${S}/get2
    doins ${S}/get3
    doins ${S}/getdist.awk
    doins ${S}/move4
    doins ${S}/move5
    doins ${S}/move6
    doins ${S}/move7

    insinto /usr/share/man/man8
    doins ${S}/apt-move.8

}