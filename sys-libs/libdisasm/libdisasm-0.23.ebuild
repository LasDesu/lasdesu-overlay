# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator 

MY_PV=$(replace_version_separator '_' '-')
DESCRIPTION="libdisasm provides basic disassembly of x86 instructions."
HOMEPAGE="http://bastard.sourceforge.net/libdisasm.html"
SRC_URI="mirror://sourceforge/bastard/${PN}-${MY_PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
