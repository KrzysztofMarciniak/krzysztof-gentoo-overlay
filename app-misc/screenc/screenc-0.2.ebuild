EAPI=8

DESCRIPTION="A screen recording utility"
HOMEPAGE="https://github.com/KrzysztofMarciniak/screenc"
SRC_URI="https://github.com/KrzysztofMarciniak/screenc/archive/refs/tags/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libpng:=
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gcc[openmp]
"

S="${WORKDIR}/${PN}-${PV}"

src_compile() {
	sh make.sh build || die "Build failed"
}

src_install() {
	dobin screenc
	dodoc README.md LICENSE || true
}

