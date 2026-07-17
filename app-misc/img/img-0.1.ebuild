EAPI=8

DESCRIPTION="Small X11 image viewer"
HOMEPAGE="https://github.com/KrzysztofMarciniak/img"
SRC_URI="https://github.com/KrzysztofMarciniak/img/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="jpeg png webp"

DEPEND="
	x11-libs/libX11
	png? ( media-libs/libpng )
	jpeg? ( media-libs/libjpeg-turbo )
	webp? ( media-libs/libwebp )
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	cat > config.mk <<-EOF || die
	CC = ${CHOST}-gcc
	CFLAGS = ${CFLAGS}
	LDFLAGS = ${LDFLAGS}

	WITH_PNG = ${PV}
	WITH_JPEG = ${PV}
	WITH_WEBP = ${PV}
	EOF

	if ! use png; then
		sed -i 's/WITH_PNG = .*/WITH_PNG = 0/' config.mk || die
	fi

	if ! use jpeg; then
		sed -i 's/WITH_JPEG = .*/WITH_JPEG = 0/' config.mk || die
	fi

	if ! use webp; then
		sed -i 's/WITH_WEBP = .*/WITH_WEBP = 0/' config.mk || die
	fi
}

src_compile() {
	emake
}

src_install() {
	dobin img
}

