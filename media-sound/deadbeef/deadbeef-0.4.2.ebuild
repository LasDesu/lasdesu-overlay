# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils flag-o-matic

DESCRIPTION="mp3/ogg/flac/sid/mod/nsf music player based on GTK2"
HOMEPAGE="http://deadbeef.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="alsa gtk dbus pulseaudio mp3 cdda vorbis flac wavpack sndfile faad ffmpeg scrobbler"

RDEPEND="media-libs/libsamplerate
	 gtk? ( >=x11-libs/gtk+-2 )
	 alsa? ( media-libs/alsa-lib )
	 vorbis? ( media-libs/libvorbis
		   media-libs/libogg )
	 scrobbler? ( net-misc/curl )
	 mp3? ( media-libs/libmad )	 
	 flac? ( media-libs/flac )
	 wavpack? ( media-sound/wavpack )
	 sndfile? ( media-libs/libsndfile )
	 cdda? ( dev-libs/libcdio
		 media-libs/libcddb )
	 ffmpeg? ( media-video/ffmpeg )
	 dbus? ( sys-apps/dbus )
	 pulseaudio? ( media-sound/pulseaudio )
	 faad? ( media-libs/faad2 )
	 sys-libs/zlib"

DEPEND=""

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

