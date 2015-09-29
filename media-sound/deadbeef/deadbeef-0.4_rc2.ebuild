# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic

DESCRIPTION="mp3/ogg/flac/sid/mod/nsf music player based on GTK2"
HOMEPAGE="http://deadbeef.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/${PN}/deadbeef-0.4-rc2.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mp3 cdda vorbis flac wavpack sndfile ffmpeg scrobbler"

RDEPEND=">=x11-libs/gtk+-2
	 media-libs/libsamplerate
	 media-libs/alsa-lib
	 mp3? ( media-libs/libmad )
	 vorbis? ( media-libs/libvorbis
		   media-libs/libogg )
	 flac? ( media-libs/flac )
	 wavpack? ( media-sound/wavpack )
	 sndfile? ( media-libs/libsndfile )
	 cdda? ( dev-libs/libcdio
		 media-libs/libcddb )
	 ffmpeg? ( media-video/ffmpeg )
	 scrobbler? ( net-misc/curl )
	 notify? ( x11-libs/libnotify )"

DEPEND=""

src_unpack() {
	unpack ${A}
	mv deadbeef-0.4-rc2 ${PF}
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

