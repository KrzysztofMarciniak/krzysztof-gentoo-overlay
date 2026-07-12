EAPI=8

DESCRIPTION="A tiny terminal text editor in less than 1000 LOC (kilo)"
HOMEPAGE="https://github.com/antirez/kilo"
SRC_URI="https://github.com/antirez/kilo/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2-clause"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/kilo-master"

src_install() {
	dobin kilo
}

src_compile() {
	emake CC="$(tc-getCC)" EXTRA_CFLAGS="${CFLAGS}" -f Makefile kilo
}

