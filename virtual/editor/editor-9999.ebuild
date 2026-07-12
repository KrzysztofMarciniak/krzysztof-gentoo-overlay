# Copyright 1999-2025 Gentoo Authors
# Modified editor file to include kilo, openvi
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for editor"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

# Add a package to RDEPEND only if the editor:
# - can edit ordinary text files,
# - works on the console,
# - is a "display" or "visual" editor (e.g., using ncurses).

RDEPEND="|| (
	app-editors/kilo	
	app-editors/openvi	
)"
