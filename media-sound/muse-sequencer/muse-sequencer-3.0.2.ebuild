# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils toolchain-funcs flag-o-matic versionator

MY_P=muse_${PV//./_}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://www.muse-sequencer.org/"
#SRC_URI="mirror://github/muse-sequencer/muse/archive/${MY_P}.tar.gz"
SRC_URI="https://github.com/muse-sequencer/muse/archive/${MY_P}.tar.gz -> ${P}.tar.gz"


LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc dssi fluidsynth lash osc vst"
REQUIRED_USE=""

CDEPEND=">=media-libs/alsa-lib-0.9.0
	>=media-libs/libsamplerate-0.1.0
	>=media-libs/libsndfile-1.0
	virtual/jack
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dssi? ( >=media-libs/dssi-0.9.0 )
	lash? ( >=media-sound/lash-0.4.0 )
	osc? ( >=media-libs/liblo-0.23 )"
RDEPEND="${CDEPEND}
	fluidsynth? ( >=media-sound/fluidsynth-0.9.0 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )"

S=${WORKDIR}/muse-${MY_P}/muse3
RESTRICT="mirror"

PATCHES=("${FILESDIR}"/${PN}-3.0.2-cmake-rpath.patch)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable dssi DSSI)
		$(cmake-utils_use_enable fluidsynth FLUID)
		$(cmake-utils_use_enable lash LASH)
		$(cmake-utils_use_enable osc OSC)
		$(cmake-utils_use_enable vst VST_NATIVE)
	)
	cmake-utils_src_configure
}
