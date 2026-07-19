EAPI=8

DESCRIPTION="su without pam."
HOMEPAGE="https://github.com/KrzysztofMarciniak/su"
SRC_URI="https://github.com/KrzysztofMarciniak/su/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="
	virtual/libcrypt
"

RDEPEND="${DEPEND}"

src_compile() {
	emake 
}

src_install() {
    dobin su
    fowners root:root /usr/bin/su
    fperms 4755 /usr/bin/su
}
