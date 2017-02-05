# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="Python api for Debian Apt"
HOMEPAGE="http://anonscm.debian.org/gitweb/?p=apt/python-apt.git"
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

#S=${S}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
        dev-python/python-debian
        dev-python/feedparser
        dev-python/python-distutils-extra 
        sys-apps/apt
        "
RDEPEND=$DEPEND

src_prepare(){
    epatch ${FILESDIR}/pkgsrcrecords.patch
}
