# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="search for files within Debian packages (command-line interface)"
HOMEPAGE=""
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/dpkg
        sys-apps/apt
        dev-util/debhelper
        dev-lang/perl
        dev-perl/libapt-pkg-perl
        dev-perl/List-MoreUtils
        dev-perl/Regexp-Assemble
        dev-perl/libconfig-file-perl"

RDEPEND="$DEPEND"

S=${WORKDIR}/${PN}

src_prepare() {
    rm ${S}/Makefile
}

src_install() {

    exeinto /usr/bin
    exeopts -m755
    doexe ${S}/apt-file
    doexe ${S}/diffindex-download
    doexe ${S}/diffindex-rred

    mv ${S}/debian/apt-file.is-cache-empty ${S}/is-cache-empty
    mv ${S}/debian/apt-file.do-apt-file-update ${S}/do-apt-file-update
    mv ${S}/debian/apt-file.update-notifier ${S}/update-notifier

    exeinto /usr/share/apt-file
    exeopts -m755
    doexe ${S}/do-apt-file-update
    doexe ${S}/is-cache-empty

    insinto /usr/share/apt-file
    doins ${S}/update-notifier

    insinto /etc/apt
    doins ${S}/apt-file.conf

    insinto /usr/share/man/man1
    doins ${FILESDIR}/apt-file.1
    doins ${FILESDIR}/diffindex-download.1
    doins ${FILESDIR}/diffindex-rred.1

    insinto /var/cache/apt/apt-file
}