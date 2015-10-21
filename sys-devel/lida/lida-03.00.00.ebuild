# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Linux Interactive DisAssembler. A disassembler and code analysis \ 
			tool."
HOMEPAGE="http://sourceforge.net/projects/lida/"
SRC_URI="mirror://sourceforge/lida/${P}.tgz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-perl/perl-tk
		>=sys-libs/libdisasm-0.16"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-fix.patch"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
