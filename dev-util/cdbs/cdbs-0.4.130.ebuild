# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="common build system for Debian packages"
HOMEPAGE=""
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="app-arch/dpkg
	sys-apps/apt
	sys-apps/gawk"
RDEPEND=${DEPEND}

#src_prepare() {
#    epatch "${FILESDIR}"/${P}-gpg.patch
#}

#src_configure() {
#	econf \
#		--with-libgpgme=no \
#		|| die
#}

src_install() {
    emake DESTDIR=${D} install || die

    exeinto /usr/bin
    exeopts -m755
    doexe ${FILESDIR}/dh_autoreconf
    doexe ${FILESDIR}/dh_autoreconf_clean
    doexe ${FILESDIR}/desktop-check-mime-types
    doexe ${FILESDIR}/dh_gnome
    doexe ${FILESDIR}/dh_gnome_clean
    doexe ${FILESDIR}/pkg-gnome-compat-desktop-file

    insinto /usr/share/cdbs/1/rules
    doins ${FILESDIR}/autoreconf.mk

    insinto /usr/share/gnome-pkg-tools/1/rules
    doins ${FILESDIR}/check-dist.mk
    doins ${FILESDIR}/clean-la.mk
    doins ${FILESDIR}/gnome-get-source.mk
    doins ${FILESDIR}/gnome-version.mk
    doins ${FILESDIR}/lp-get-source.mk
    doins ${FILESDIR}/make-compat-desktop-file.mk
    doins ${FILESDIR}/patch-translations.mk
    doins ${FILESDIR}/sf-get-source.mk
    doins ${FILESDIR}/ubuntu-get-source.mk
    doins ${FILESDIR}/uploaders.mk
}
