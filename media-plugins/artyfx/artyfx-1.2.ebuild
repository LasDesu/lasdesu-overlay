# Copyright 1999-2010 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2 
# $Header: $ 

EAPI=2 
inherit cmake-utils 

DESCRIPTION="" 
HOMEPAGE="" 
SRC_URI="https://github.com/harryhaaren/openAV-ArtyFX/archive/release-${PV}.tar.gz" 

LICENSE="" 
SLOT="0" 
KEYWORDS="~amd64 ~x86" 
IUSE="" 

RDEPEND="
	media-libs/lv2
	x11-libs/ntk
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
	
CMAKE_USE_DIR="${WORKDIR}/openAV-ArtyFX-release-${PV}"
	
src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}
