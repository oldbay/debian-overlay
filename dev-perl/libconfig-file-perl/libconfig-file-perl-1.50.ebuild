# Copyright 2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Perl interface to libapt-pkg"
HOMEPAGE=""
SRC_URI="mirror://debian/pool/main/${PN:0:4}/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND="dev-lang/perl
	dev-perl/Pod-Tests"
RDEPEND=${DEPEND}

S="${WORKDIR}/Config-File-${PV}"

src_configure() {
    perl ${S}/Makefile.PL INSTALLDIRS=vendor || die
}

src_build() {
	emake OPTIMIZE="-O2 -g -Wall" || die
}

src_install() {
	emake DESTDIR=${D} install || die
}
