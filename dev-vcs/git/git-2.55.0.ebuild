# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

MY_PV="${PV}-wd40"
MY_P="git-${MY_PV}"

DESCRIPTION="Libre WD-40: a de-Microsofted fork of the Git version control system"
HOMEPAGE="https://github.com/Libre-WD-40/git"
SRC_URI="https://github.com/Libre-WD-40/git/archive/refs/tags/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm64"

IUSE="bash-completion curl doc gpg +iconv mediawiki +nls +pcre +perl python subversion tk webdav"
REQUIRED_USE="webdav? ( curl )"

# Same on-disk layout (/usr/bin/git, man pages, libexec helpers) as
# dev-vcs/git since this is a source-level fork -- the two cannot coexist.
# Keep gitwd40 the exclusive provider of "git" when installed.
RDEPEND="
	!dev-vcs/git
	!app-misc/git
	sys-libs/zlib
	curl? (
		net-misc/curl
		webdav? ( dev-libs/expat )
	)
	gpg? ( app-crypt/gnupg )
	iconv? ( virtual/libiconv )
	nls? ( virtual/libintl )
	pcre? ( dev-libs/libpcre2 )
	perl? ( dev-lang/perl:= )
	python? ( dev-lang/python:= )
	subversion? ( dev-vcs/subversion[perl] )
	tk? ( dev-lang/tk:0= )
	mediawiki? ( dev-perl/HTML-Parser dev-perl/URI )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/asciidoc app-text/xmlto )
"

pkg_pretend() {
	if has_version dev-vcs/git; then
		ewarn "dev-vcs/git is currently installed. app-misc/gitwd40 blocks it"
		ewarn "(RDEPEND=\"!dev-vcs/git\"), so 'emerge' will refuse to merge"
		ewarn "both at once and will prompt you to unmerge dev-vcs/git first."
	fi
}

src_prepare() {
	default
	use nls || sed -i -e '/^ALL_LDFLAGS/s/$/ NO_GETTEXT=1/' config.mak.uname 2>/dev/null
}

src_configure() {
	tc-export CC AR
}

src_compile() {
	local myopts=(
		V=1
		CC="$(tc-getCC)"
		AR="$(tc-getAR)"
		prefix="${EPREFIX}/usr"
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		sysconfdir="${EPREFIX}/etc"
		INSTALL=install
		OPTAR="$(tc-getAR)"
		NO_TCLTK="$(usex tk '' 1)"
		NO_PYTHON="$(usex python '' 1)"
		NO_PERL="$(usex perl '' 1)"
		NO_GETTEXT="$(usex nls '' 1)"
		NO_ICONV="$(usex iconv '' 1)"
		USE_LIBPCRE2="$(usex pcre 1 '')"
		NO_EXPAT="$(usex webdav '' 1)"
		NO_CURL="$(usex curl '' 1)"
	)
	use curl && myopts+=( CURL_CONFIG="$(type -P curl-config)" )

	emake "${myopts[@]}" all
	use doc && emake "${myopts[@]}" man html
}

src_install() {
	local myopts=(
		prefix="${EPREFIX}/usr"
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		sysconfdir="${EPREFIX}/etc"
		DESTDIR="${D}"
		NO_TCLTK="$(usex tk '' 1)"
		NO_PYTHON="$(usex python '' 1)"
		NO_PERL="$(usex perl '' 1)"
		NO_GETTEXT="$(usex nls '' 1)"
		NO_ICONV="$(usex iconv '' 1)"
		USE_LIBPCRE2="$(usex pcre 1 '')"
		NO_EXPAT="$(usex webdav '' 1)"
		NO_CURL="$(usex curl '' 1)"
	)
	use curl && myopts+=( CURL_CONFIG="$(type -P curl-config)" )

	emake "${myopts[@]}" install
	use doc && emake "${myopts[@]}" install-man install-html

	dodoc README.md Documentation/RelNotes/*.adoc

	if use bash-completion; then
		newbashcomp contrib/completion/git-completion.bash git
		bashcomp_alias git gitk
	fi

	if use mediawiki; then
		emake "${myopts[@]}" -C contrib/mw-to-git install
	fi
}

pkg_postinst() {
	elog "This is the Libre WD-40 fork of git (${HOMEPAGE}),"
	elog "installed as app-misc/gitwd40. It provides the same 'git' binary"
	elog "as dev-vcs/git and is intentionally blocked against it -- only"
	elog "one of the two may be installed at a time."
}
