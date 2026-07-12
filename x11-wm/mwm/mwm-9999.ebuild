EAPI=8

SLOT="0"
KEYWORDS="amd64 ~x86"
DESCRIPTION="mwm (minimal-window-manager)"
HOMEPAGE="https://github.com/KrzysztofMarciniak/minimal-window-manager"
LICENSE="all-rights-reserved"

SRC_URI="https://github.com/KrzysztofMarciniak/minimal-window-manager/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

src_compile() {
	emake
}

src_install() {
	exeinto /usr/local/bin
	doexe mwm
}

pkg_postinst() {
	elog "Installed mwm to /usr/local/bin/mwm"
}

