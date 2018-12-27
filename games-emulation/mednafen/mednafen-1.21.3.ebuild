# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic pax-utils

DESCRIPTION="Argument-driven multi-system emulator utilizing OpenGL and SDL"
HOMEPAGE="https://mednafen.github.io/"
SRC_URI="https://mednafen.github.io/releases/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa altivec cjk debugger jack sndfile nls pax_kernel"

RDEPEND="
	dev-libs/libcdio
	>=dev-libs/lzo-2.10
	media-libs/libsdl[sound,joystick,opengl,video]
	sys-libs/zlib
	virtual/opengl
	media-libs/tremor
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	sndfile? ( media-libs/libsndfile )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "If you experience build failure, try turning off ccache in FEATURES."
		ewarn
	fi
}

src_prepare() {
	default

	# Unfortunately, upstream is insane and thinks mucking with CFLAGS is okay, if
	# it prevents "users who don't understand the consequences of what they're doing".
	# We use sed's here, as they're more forward-compatible than patches which need to
	# be constantly rebased. DO NOT REPLACE THEM UNLESS YOU HAVE PERMISSION FROM GAMES.
	sed -e '/-fno-fast-math/d' \
		-e '/-fno-unsafe-math-optimizations/d' \
		-e '/-fno-aggressive-loop-optimizations/d' \
		-e '/-fno-ipa-icf/d' \
		-e '/-fno-printf-return-value/d' \
		-e '/-fomit-frame-pointer/d' \
		-e '/-fno-pic/d' \
		-e '/-fno-pie/d' \
		-e '/-fno-PIC/d' \
		-e '/-fno-PIE/d' \
		-e '/-nopie/d' \
		-e '/-no-pie/d' \
		-e '/-fno-stack-protector/d' \
		-e '/-fno-stack-protector-all/d' \
		-e '/-fno-stack-protector-strong/d' \
		-e '/-mtune=haswell/d' \
		-i configure.ac || die

	# The insanity continues... upstream now believes it needs to
	# warn users when compiling with -fPIC/-fPIE enabled
	sed -e '/Compiling with position-independent code generation enabled is not recommended, for performance reasons/d' \
		-i src/types.h || die

	eautoreconf
}

src_configure() {
	# very dodgy code (bug #539992)
	strip-flags
	append-flags -fomit-frame-pointer -fwrapv

	econf \
		--with-external-lzo \
		--with-external-tremor \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debugger) \
		$(use_enable jack) \
		$(use_with sndfile libsndfile) \
		$(use_enable nls)
}

src_install() {
	default
	dodoc Documentation/cheats.txt

	if use pax_kernel; then
		pax-mark m "${ED%/}"/usr/bin/mednafen || die
	fi
}
