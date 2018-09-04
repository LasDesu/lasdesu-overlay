# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit python-single-r1 gnome2-utils

[[ "${PV}" = "9999" ]] && inherit git-r3

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="http://kxstudio.linuxaudio.org"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

MY_P=Carla-${PV}

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/falkTX/Carla.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/falkTX/Carla/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="-pulseaudio ffmpeg"

RDEPEND="${PYTHON_DEPS}
	media-sound/jack2[dbus]
	dev-python/PyQt5[dbus,gui,widgets,${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	pulseaudio? ( media-sound/pulseaudio[jack] )"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e "s/python3/${EPYTHON}/" \
		data/carla \
		data/carla-control \
		data/carla-database \
		data/carla-jack-multi \
		data/carla-jack-single \
		data/carla-patchbay \
		data/carla-rack \
		data/carla-settings \
		data/carla-single || die "sed failed"
	default
}

src_compile() {
	myemakeargs=(PREFIX="/usr"
		SKIP_STRIPPING=true
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
