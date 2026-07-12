EAPI=8

DESCRIPTION="An upscaled version of scientifica (Curie bitmap font)"
HOMEPAGE="https://github.com/oppiliappan/curie"
SRC_URI="https://github.com/oppiliappan/curie/releases/download/v1.0/curie-v1.0.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="mirror"

S="${WORKDIR}/curie-v1.0"

src_install() {
	insinto /usr/share/fonts/curie
	doins -r "${S}"/regular "${S}"/bold "${S}"/italic
}

