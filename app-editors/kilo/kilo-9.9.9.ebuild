EAPI=8
inherit toolchain-funcs

DESCRIPTION="A tiny terminal text editor in less than 1000 LOC (kilo)"
HOMEPAGE="https://github.com/antirez/kilo"
LICENSE="BSD-2-clause"

SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/antirez/kilo/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/kilo-master"

src_compile() {
	emake
}

src_install() {
	dobin kilo
}

