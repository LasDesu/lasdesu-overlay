# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIVALDI_HOME="opt/vivaldi-snapshot"
DESCRIPTION="Additional proprietary codecs for Vivaldi web browser, stable release."
HOMEPAGE="http://www.vivaldi.net"
SRC_URI="
   amd64? ( https://repo.herecura.eu/herecura/x86_64/${P}-1-x86_64.pkg.tar.xz )
   x86? ( https://repo.herecura.eu/herecura/i686/${P}-1-i686.pkg.tar.xz )
"

LICENSE="LGPL2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="www-client/vivaldi"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
   unpack ${A}
}

src_install() {
   cd ${S}
   mkdir -p ${D}/${VIVALDI_HOME}
   cp ${S}/${VIVALDI_HOME}/libffmpeg.so ${D}/${VIVALDI_HOME}/libffmpeg.so
}
