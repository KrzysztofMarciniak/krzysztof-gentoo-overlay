EAPI=8
inherit toolchain-funcs

DESCRIPTION="afetch (tiny terminal text editor in less than 1000 LOC; project afetch)"
HOMEPAGE="https://github.com/13-CF/afetch"
LICENSE="GPL-3.0"

SLOT="0"
KEYWORDS="amd64 ~x86"

SRC_URI="https://github.com/13-CF/afetch/archive/refs/tags/V2.2.0.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/afetch-2.2.0"

src_compile() {
	emake
}

src_install() {
	exeinto /usr/local/bin
	doexe afetch
}

