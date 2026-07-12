EAPI=8

DESCRIPTION="OpenVi - OpenBSD vi clone"
HOMEPAGE="https://github.com/johnsonjh/OpenVi"
SRC_URI="https://github.com/johnsonjh/OpenVi/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	sys-libs/ncurses
"

RDEPEND="${DEPEND}"

BDEPEND="
	sys-devel/make
"

S="${WORKDIR}/OpenVi-${PV}"

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
