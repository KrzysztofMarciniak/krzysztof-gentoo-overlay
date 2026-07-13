EAPI=8

DESCRIPTION="A screen recording utility"
HOMEPAGE="https://github.com/KrzysztofMarciniak/screenc"
SRC_URI="https://github.com/KrzysztofMarciniak/screenc/archive/refs/tags/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libpng:=
	x11-libs/libX11
	sys-devel/gcc
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${PV}"

src_compile() {
	./build.sh build || die "Build failed"
}

src_install() {
	dobin screenc
	dodoc README* LICENSE* || true
}

