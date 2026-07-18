# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="suckless st terminal, flexipatch build with preprocessor-selectable patches"
HOMEPAGE="https://github.com/bakkeby/st-flexipatch https://st.suckless.org/"

#SRC_URI="https://github.com/KrzysztofMarciniak/st-flexipatch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/KrzysztofMarciniak/st-flexipatch/archive/refs/tags/0.9.3.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"

# ---------------------------------------------------------------------------
# curie is not an upstream flexipatch toggle - it's a local addition that
# sets media-fonts/curie as the default font via
# files/st-0.9.3-default-font-curie.patch. Enabled by default; disable
# with USE="-curie" to keep upstream's Liberation Mono default and skip
# the media-fonts/curie dependency.
#
# The rest are one USE flag per flexipatch toggle in patches.def.h,
# prefixed with st_patch_ so they don't collide with global USE flags.
# ---------------------------------------------------------------------------
IUSE="
	+curie
	+st_patch_alpha
	st_patch_alpha_focus_highlight
	st_patch_alpha_gradient
	st_patch_anygeometry
	st_patch_anysize
	st_patch_anysize_simple
	st_patch_background_image
	st_patch_background_image_reload
	st_patch_blinking_cursor
	st_patch_bold_is_not_bright
	+st_patch_boxdraw
	+st_patch_clipboard
	+st_patch_columns
	st_patch_copyurl
	st_patch_copyurl_highlight_selected_urls
	st_patch_csi_22_23
	st_patch_default_cursor
	+st_patch_delkey
	st_patch_disable_bold_fonts
	st_patch_disable_italic_fonts
	st_patch_disable_roman_fonts
	st_patch_drag_and_drop
	st_patch_dynamic_cursor_color
	st_patch_dynamic_padding
	st_patch_externalpipe
	st_patch_externalpipein
	st_patch_fixkeyboardinput
	st_patch_font2
	st_patch_fullscreen
	st_patch_hidecursor
	st_patch_hide_terminal_cursor
	st_patch_invert
	st_patch_iso14755
	st_patch_keyboardselect
	st_patch_ligatures
	+st_patch_monochrome
	st_patch_netwmicon
	st_patch_netwmicon_ff
	st_patch_netwmicon_legacy
	st_patch_newterm
	st_patch_no_window_decorations
	st_patch_opencopied
	st_patch_open_selected_text
	st_patch_openurlonclick
	st_patch_osc7
	st_patch_osc133
	st_patch_reflow
	st_patch_relativeborder
	st_patch_rightclicktoplumb
	st_patch_scrollback
	st_patch_scrollback_mouse
	st_patch_scrollback_mouse_altscreen
	st_patch_selection_colors
	st_patch_selectionbg_alpha
	st_patch_single_drawable_buffer
	st_patch_sixel
	st_patch_st_embedder
	st_patch_spoiler
	st_patch_swapmouse
	st_patch_sync
	st_patch_themed_cursor
	st_patch_undercurl
	st_patch_universcroll
	st_patch_use_xftfontmatch
	st_patch_vertcenter
	st_patch_visualbell
	st_patch_w3m
	st_patch_wide_glyphs
	st_patch_wide_glyph_spacing
	+st_patch_workingdir
	st_patch_xresources
	st_patch_xresources_reload
	st_patch_xresources_xdefaults
"

# ---------------------------------------------------------------------------
# Dependency / incompatibility graph as documented in patches.def.h
# ---------------------------------------------------------------------------
REQUIRED_USE="
	st_patch_alpha_focus_highlight? ( st_patch_alpha )
	st_patch_alpha_gradient? ( st_patch_alpha )
	st_patch_background_image_reload? ( st_patch_background_image )
	st_patch_dynamic_padding? ( st_patch_anysize )
	st_patch_externalpipein? ( st_patch_externalpipe )
	st_patch_osc7? ( st_patch_newterm )
	st_patch_osc133? ( || ( st_patch_reflow st_patch_scrollback ) )
	st_patch_scrollback_mouse? ( st_patch_scrollback )
	st_patch_scrollback_mouse_altscreen? ( st_patch_scrollback )
	st_patch_selectionbg_alpha? ( st_patch_alpha st_patch_selection_colors )
	st_patch_xresources_reload? ( st_patch_xresources )
	st_patch_xresources_xdefaults? ( st_patch_xresources )
	st_patch_sixel? ( !st_patch_w3m )
	st_patch_w3m? ( !st_patch_sixel )
	?? ( st_patch_netwmicon st_patch_netwmicon_ff st_patch_netwmicon_legacy )
"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
	media-libs/fontconfig
	media-libs/freetype:2
	curie? ( media-fonts/curie )
	st_patch_alpha? ( x11-libs/libXrender )
	st_patch_themed_cursor? ( x11-libs/libXcursor )
	st_patch_ligatures? ( media-libs/harfbuzz )
	st_patch_sixel? ( media-libs/imlib2 )
	st_patch_netwmicon? ( media-libs/gd )
	st_patch_w3m? ( www-client/w3m )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-libs/ncurses
"

# ---------------------------------------------------------------------------
# flag:MACRO pairs - maps each USE flag to its #define in patches.def.h
# ---------------------------------------------------------------------------
_ST_PATCH_MAP=(
	"st_patch_alpha:ALPHA_PATCH"
	"st_patch_alpha_focus_highlight:ALPHA_FOCUS_HIGHLIGHT_PATCH"
	"st_patch_alpha_gradient:ALPHA_GRADIENT_PATCH"
	"st_patch_anygeometry:ANYGEOMETRY_PATCH"
	"st_patch_anysize:ANYSIZE_PATCH"
	"st_patch_anysize_simple:ANYSIZE_SIMPLE_PATCH"
	"st_patch_background_image:BACKGROUND_IMAGE_PATCH"
	"st_patch_background_image_reload:BACKGROUND_IMAGE_RELOAD_PATCH"
	"st_patch_blinking_cursor:BLINKING_CURSOR_PATCH"
	"st_patch_bold_is_not_bright:BOLD_IS_NOT_BRIGHT_PATCH"
	"st_patch_boxdraw:BOXDRAW_PATCH"
	"st_patch_clipboard:CLIPBOARD_PATCH"
	"st_patch_columns:COLUMNS_PATCH"
	"st_patch_copyurl:COPYURL_PATCH"
	"st_patch_copyurl_highlight_selected_urls:COPYURL_HIGHLIGHT_SELECTED_URLS_PATCH"
	"st_patch_csi_22_23:CSI_22_23_PATCH"
	"st_patch_default_cursor:DEFAULT_CURSOR_PATCH"
	"st_patch_delkey:DELKEY_PATCH"
	"st_patch_disable_bold_fonts:DISABLE_BOLD_FONTS_PATCH"
	"st_patch_disable_italic_fonts:DISABLE_ITALIC_FONTS_PATCH"
	"st_patch_disable_roman_fonts:DISABLE_ROMAN_FONTS_PATCH"
	"st_patch_drag_and_drop:DRAG_AND_DROP_PATCH"
	"st_patch_dynamic_cursor_color:DYNAMIC_CURSOR_COLOR_PATCH"
	"st_patch_dynamic_padding:DYNAMIC_PADDING_PATCH"
	"st_patch_externalpipe:EXTERNALPIPE_PATCH"
	"st_patch_externalpipein:EXTERNALPIPEIN_PATCH"
	"st_patch_fixkeyboardinput:FIXKEYBOARDINPUT_PATCH"
	"st_patch_font2:FONT2_PATCH"
	"st_patch_fullscreen:FULLSCREEN_PATCH"
	"st_patch_hidecursor:HIDECURSOR_PATCH"
	"st_patch_hide_terminal_cursor:HIDE_TERMINAL_CURSOR_PATCH"
	"st_patch_invert:INVERT_PATCH"
	"st_patch_iso14755:ISO14755_PATCH"
	"st_patch_keyboardselect:KEYBOARDSELECT_PATCH"
	"st_patch_ligatures:LIGATURES_PATCH"
	"st_patch_monochrome:MONOCHROME_PATCH"
	"st_patch_netwmicon:NETWMICON_PATCH"
	"st_patch_netwmicon_ff:NETWMICON_FF_PATCH"
	"st_patch_netwmicon_legacy:NETWMICON_LEGACY_PATCH"
	"st_patch_newterm:NEWTERM_PATCH"
	"st_patch_no_window_decorations:NO_WINDOW_DECORATIONS_PATCH"
	"st_patch_opencopied:OPENCOPIED_PATCH"
	"st_patch_open_selected_text:OPEN_SELECTED_TEXT_PATCH"
	"st_patch_openurlonclick:OPENURLONCLICK_PATCH"
	"st_patch_osc7:OSC7_PATCH"
	"st_patch_osc133:OSC133_PATCH"
	"st_patch_reflow:REFLOW_PATCH"
	"st_patch_relativeborder:RELATIVEBORDER_PATCH"
	"st_patch_rightclicktoplumb:RIGHTCLICKTOPLUMB_PATCH"
	"st_patch_scrollback:SCROLLBACK_PATCH"
	"st_patch_scrollback_mouse:SCROLLBACK_MOUSE_PATCH"
	"st_patch_scrollback_mouse_altscreen:SCROLLBACK_MOUSE_ALTSCREEN_PATCH"
	"st_patch_selection_colors:SELECTION_COLORS_PATCH"
	"st_patch_selectionbg_alpha:SELECTIONBG_ALPHA_PATCH"
	"st_patch_single_drawable_buffer:SINGLE_DRAWABLE_BUFFER_PATCH"
	"st_patch_sixel:SIXEL_PATCH"
	"st_patch_st_embedder:ST_EMBEDDER_PATCH"
	"st_patch_spoiler:SPOILER_PATCH"
	"st_patch_swapmouse:SWAPMOUSE_PATCH"
	"st_patch_sync:SYNC_PATCH"
	"st_patch_themed_cursor:THEMED_CURSOR_PATCH"
	"st_patch_undercurl:UNDERCURL_PATCH"
	"st_patch_universcroll:UNIVERSCROLL_PATCH"
	"st_patch_use_xftfontmatch:USE_XFTFONTMATCH_PATCH"
	"st_patch_vertcenter:VERTCENTER_PATCH"
	"st_patch_visualbell:VISUALBELL_1_PATCH"
	"st_patch_w3m:W3M_PATCH"
	"st_patch_wide_glyphs:WIDE_GLYPHS_PATCH"
	"st_patch_wide_glyph_spacing:WIDE_GLYPH_SPACING_PATCH"
	"st_patch_workingdir:WORKINGDIR_PATCH"
	"st_patch_xresources:XRESOURCES_PATCH"
	"st_patch_xresources_reload:XRESOURCES_RELOAD_PATCH"
	"st_patch_xresources_xdefaults:XRESOURCES_XDEFAULTS_PATCH"
)

src_unpack() {
	default

	# GitHub commit-archive tarballs name their top-level directory
	# "<repo>-<sha>" (here "st-flexipatch-${COMMIT}"), which never matches
	# our S. Rather than hardcoding that name (and re-breaking if GitHub's
	# scheme, the ref type, or the distfile ever differs), just rename
	# whatever single directory got unpacked to what S expects.
	local unpacked
	unpacked=$(find "${WORKDIR}" -mindepth 1 -maxdepth 1 -type d)
	if [[ $(wc -l <<< "${unpacked}") -ne 1 ]]; then
		die "expected exactly one top-level directory in ${WORKDIR}, found: ${unpacked}"
	fi
	[[ "${unpacked}" == "${S}" ]] || mv "${unpacked}" "${S}" || die "failed to normalize source dir"
}

src_prepare() {
	default

	if use curie; then
		sed -i -E 's/^(static char \*font = )".*"(;)/\1"curie:pixelsize=12:antialias=true:autohint=true"\2/' \
			config.def.h || die "failed to set curie as default font"
		grep -q '"curie:' config.def.h || die "curie font substitution did not take effect"
	fi

	local pair flag macro state
	for pair in "${_ST_PATCH_MAP[@]}"; do
		flag="${pair%%:*}"
		macro="${pair##*:}"
		use "${flag}" && state=1 || state=0
		sed -i -E "s/^(#define[[:space:]]+${macro}[[:space:]]+)[01]/\1${state}/" \
			patches.def.h || die "failed to toggle ${macro}"
	done

	# Enable the extra libraries in config.mk that individual patches need.
	if use st_patch_alpha; then
		sed -i -E 's/^#(XRENDER[[:space:]]*=.*)/\1/' config.mk || die
	fi
	if use st_patch_themed_cursor; then
		sed -i -E 's/^#(XCURSOR[[:space:]]*=.*)/\1/' config.mk || die
	fi
	if use st_patch_ligatures; then
		sed -i -E 's/^#(LIGATURES_(C|H|INC|LIBS)[[:space:]]*=.*)/\1/' config.mk || die
	fi
	if use st_patch_sixel; then
		sed -i -E 's/^#(SIXEL_(C|LIBS)[[:space:]]*=.*)/\1/' config.mk || die
	fi
	if use st_patch_netwmicon; then
		sed -i -E 's/^#(NETWMICON_LIBS[[:space:]]*=.*)/\1/' config.mk || die
	fi
}

src_configure() {
	tc-export CC PKG_CONFIG
	# st's Makefile hardcodes some flags via config.mk; keep our CFLAGS too.
	append-cflags -std=c99 -pedantic
}

src_compile() {
	emake 
}

src_install() {

	exeinto /usr/local/bin
	doexe st

}
