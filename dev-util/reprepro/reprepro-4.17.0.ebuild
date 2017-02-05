# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Debian package repository producer"
HOMEPAGE="http://mirorer.alioth.debian.org"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="app-arch/dpkg
	sys-apps/apt
	>=sys-libs/db-5.1.29"
RDEPEND=${DEPEND}

#src_prepare() {
#    epatch "${FILESDIR}"/${P}-gpg.patch
#}

src_configure() {
	econf \
		--with-libgpgme=no \
		|| die
}

src_install() {
	emake DESTDIR=${D} install || die
}
