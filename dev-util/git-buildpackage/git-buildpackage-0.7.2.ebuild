
EAPI=5

PYTHON_COMPAT=( python{2_7,3_4})

inherit distutils-r1

DESCRIPTION="Suite to help with Debian packages in Git repositories"
HOMEPAGE=""
SRC_URI="https://launchpad.net/debian/+archive/primary/+files/${PN}_${PV}.tar.xz"

#S=${S}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#python-pkg-resources
DEPEND="
        dev-python/python-debian
        dev-python/pychecker
        dev-python/coverage
        dev-python/python-dateutil
        dev-python/epydoc
        dev-python/mock
        dev-python/nose
        dev-python/nosexcover
        app-arch/rpm
        dev-python/six
        dev-python/setuptools
        dev-python/requests
        dev-vcs/git
        dev-python/git-python
        dev-util/cowdancer
        "
RDEPEND=$DEPEND

#src_prepare(){
#    epatch ${FILESDIR}/1.patch
#}

src_install() {
    distutils-r1_src_install

    insinto /etc/git-buildpackage
    doins ${FILESDIR}/gbp.conf
}
