EAPI=8

inherit git-r3

DESCRIPTION="mwm+ (minimal-window-manager plus)"
HOMEPAGE="https://github.com/KrzysztofMarciniak/minimal-window-manager-plus"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EGIT_REPO_URI="https://github.com/KrzysztofMarciniak/minimal-window-manager-plus.git"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_compile() {
        emake CFLAGS="${CFLAGS} -DSTATUS_BAR_SCRIPT=\\\"/usr/share/mwmp/status_bar_script.sh\\\""
}

src_install() {
        emake DESTDIR="${D}" PREFIX="/usr" install

        insinto /usr/share/mwmp
        doins status_bar_script.sh

        exeinto /usr/share/mwmp
        doexe audio.sh
}
