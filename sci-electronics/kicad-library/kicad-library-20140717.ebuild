# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/kicad/kicad-20130518.ebuild,v 1.1 2013/06/06 19:24:31 calchan Exp $

EAPI="5"

inherit eutils unpacker cmake-utils 

DESCRIPTION="Electronic Schematic and PCB design tools library."
HOMEPAGE="http://www.kicad-pcb.org"

RELEASE_DATE="20140717"
BZR_REV="5006"

SRC_URI="http://downloads.mad-hacking.net/software/${PN}-${RELEASE_DATE}+${BZR_REV}.tar.bz2"

LICENSE="GPL-2 kicad-doc"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-util/cmake-2.6.4"
RDEPEND="!<sci-electronics/kicad-20140717"

S="${WORKDIR}/${PN}-${RELEASE_DATE}+${BZR_REV}"

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
