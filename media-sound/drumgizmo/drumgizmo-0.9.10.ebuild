# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Hardware accelerated video decoding through VA-API plugin"
HOMEPAGE="http://gitorious.org/vaapi/gstreamer-vaapi"
SRC_URI="http://www.drumgizmo.org/releases/${P}/${P}.tar.gz"

LICENSE=""
SLOT="0.10"
KEYWORDS="~amd64"
IUSE="cli alsa jack lv2 -midifile"

RDEPEND="
	x11-libs/libX11
	media-libs/zita-resampler
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	midifile? ( >=media-libs/libsmf-1.2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable cli) \
		$(use_enable alsa output-alsa) \
		$(use_enable jack output-jackaudio) \
		$(use_enable midifile input-midifile) \
		$(use_enable lv2)	
}

src_compile() {
	default
}

src_install() {
	default
}
