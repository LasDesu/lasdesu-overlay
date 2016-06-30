# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

MY_P="${PN}-1.0.0-preview-7"

HOMEPAGE="https://sourceforge.net/projects/aspeqt/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed -i ${PN}.pro -e "/^doc.path =/s/${PN}/${PF}/" \
		|| die "sed docdir failed"
}

src_configure() {
	eqmake5
}

src_install() {
	dobin AspeQt || die
	
	make_desktop_entry AspeQt AspeQt
}
