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

src_compile() {
	emake \
		WITH_PNG=$(usex png 1 0) \
		WITH_JPEG=$(usex jpeg 1 0) \
		WITH_WEBP=$(usex webp 1 0)
}

src_install() {
	dobin img
}

