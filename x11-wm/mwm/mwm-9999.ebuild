EAPI=8

inherit git-r3

DESCRIPTION="mwm (minimal-window-manager)"
HOMEPAGE="https://github.com/KrzysztofMarciniak/minimal-window-manager"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/KrzysztofMarciniak/minimal-window-manager.git"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"


src_compile() {
	emake
}

src_install() {
	exeinto /usr/local/bin
	doexe mwm
}

