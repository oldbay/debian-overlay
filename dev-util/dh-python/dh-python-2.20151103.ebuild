# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Debian helper tools for packaging Python libraries and applications"
HOMEPAGE=""
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python
        dev-lang/perl
        dev-util/debhelper"
RDEPEND=$DEPEND

S=${WORKDIR}/${PN}

src_prepare() {
    sed -i -e 's|rst2man $< > $@|rst2man.py $< > $@|g' Makefile
    sed -i -e 's|rst2html $< > $@|rst2html.py $< > $@|g' Makefile
}

src_build() {
    emake
}

src_install() {

    DESTDIR=${D} PREFIX=/usr emake install manpages
    PerlNum=`perldoc -l Time::HiRes|awk -F "/" '{print $5}'`

    dodir /usr/bin
    dosym /usr/share/dh-python/pybuild /usr/bin/pybuild
    dosym /usr/share/dh-python/dh_pypy /usr/bin/dh_pypy
    dosym /usr/share/dh-python/dh_python2 /usr/bin/dh_python2
    dosym /usr/share/dh-python/dh_python3 /usr/bin/dh_python3
    
    dodir /usr/lib64/perl5/vendor_perl/5.20.2/Debian/Debhelper/Sequence
    dosym /usr/share/perl5/Debian/Debhelper/Sequence/pypy.pm /usr/lib64/perl5/vendor_perl/${PerlNum}/Debian/Debhelper/Sequence/pypy.pm
    dosym /usr/share/perl5/Debian/Debhelper/Sequence/python2.pm /usr/lib64/perl5/vendor_perl/${PerlNum}/Debian/Debhelper/Sequence/python2.pm
    dosym /usr/share/perl5/Debian/Debhelper/Sequence/python3.pm /usr/lib64/perl5/vendor_perl/${PerlNum}/Debian/Debhelper/Sequence/python3.pm

}