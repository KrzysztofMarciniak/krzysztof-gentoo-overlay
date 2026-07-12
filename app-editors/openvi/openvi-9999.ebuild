EAPI=8

inherit git-r3

DESCRIPTION="OpenVi - OpenBSD vi clone"
HOMEPAGE="https://github.com/johnsonjh/OpenVi"
EGIT_REPO_URI="https://github.com/johnsonjh/OpenVi.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sys-libs/ncurses
"

RDEPEND="${DEPEND}"

BDEPEND="
	sys-devel/make
"

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
