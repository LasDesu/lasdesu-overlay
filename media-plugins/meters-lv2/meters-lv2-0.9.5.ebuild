# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base multilib

DESCRIPTION="A colletion of audio level meters with GUI in LV2 plugin format"
HOMEPAGE="http://github.com/x42/meters.lv2"

GITHUB_URI="github.com/x42/meters.lv2"
SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/x42/robtk/archive/v0.5.4.tar.gz -> robtk-0.5.4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/lv2
	x11-libs/pango
	x11-libs/cairo
	virtual/opengl
	x11-libs/gtk+:2"
RDEPEND=""

DOCS=( AUTHORS README.md )

S="${WORKDIR}/meters.lv2-${PV}"
export RW="${WORKDIR}/robtk-0.5.4/"

src_configure() {
	echo "Nothing to configure"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" LIBDIR="$(get_libdir)" install
	base_src_install_docs
}
