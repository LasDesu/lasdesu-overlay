# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
if [[ "${PV}" = "9999" ]] ; then
	inherit git-2
fi
inherit multilib

DESCRIPTION="convoLV2 is a lv2 plugin to convolve audio signals"
HOMEPAGE="http://github.com/x42/convoLV2"

if [[ "${PV}" = "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/x42/convoLV2.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/x42/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="media-libs/lv2
	>=media-libs/zita-convolver-3.0.0
	media-libs/libsndfile
	x11-libs/gtk+:2"
RDEPEND=""

DOCS=( README.md )

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LV2DIR="/usr/$(get_libdir)/lv2" install
}
