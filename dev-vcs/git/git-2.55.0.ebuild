# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

MY_PV="${PV}-wd40"
MY_P="git-${MY_PV}"

DESCRIPTION="Libre WD-40: a de-rusted fork of the Git version control system"
HOMEPAGE="https://github.com/Libre-WD-40/git"
SRC_URI="https://github.com/Libre-WD-40/git/archive/refs/tags/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm64"

IUSE="bash-completion curl doc gpg iconv mediawiki nls pcre perl python subversion tk webdav"
REQUIRED_USE="webdav? ( curl )"

# This lives at dev-vcs/git (same category/name as the official package,
# just from this overlay) so anything with a dependency on dev-vcs/git
# -- including USE-conditional atoms like [curl] -- is satisfied directly
# by Portage, with no blockers or package.provided needed. Set this
# repository's priority/masking so it's the one Portage picks for that
# atom.
RDEPEND="
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

src_prepare() {
	default
	sed -i 's/"git version %s\\n", git_version_string/"git-wd40 version %s\\n", git_version_string/' \
		help.c || die "failed to patch version string"
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

	dosym git /usr/bin/git-wd40
}

pkg_postinst() {
	elog "This is the Libre WD-40 fork of git (${HOMEPAGE}),"
	elog "replacing the official dev-vcs/git ebuild via this overlay."
}
