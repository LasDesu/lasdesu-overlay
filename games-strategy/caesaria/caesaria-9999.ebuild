# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ "${PV}" == "9999" ]]; then
	MY_INHERIT=git-r3
fi

inherit games $MY_INHERIT cmake-utils

DESCRIPTION="Remake of the Caesar III strategy game"
HOMEPAGE="https://bitbucket.org/dalerank/caesaria"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://bitbucket.org/dalerank/caesaria.git"
	KEYWORDS=""
else
	SRC_URI="https://bitbucket.org/dalerank/caesaria/get/stable.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="GPL-3"
SLOT="0"

DEPEND="media-libs/libsdl
	media-libs/libpng
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	"
RDEPEND="${DEPEND}"

MY_DATADIR="${GAMES_DATADIR}"/${PN}

src_unpack() {
	if [[ "${PV}" != "9999" ]]; then
		default
		mv "${WORKDIR}"/* "${WORKDIR}/${P}"
	else
		git-r3_src_unpack
	fi
}

src_prepare() {
	# use system libraries if possible
	#epatch ${FILESDIR}/caesaria-systemlibs.patch
	
	epatch ${FILESDIR}/caesaria-minizip.patch

	# disable updater
	sed -i "s/add_subdirectory(updater updater)//g" CMakeLists.txt || die
}

src_configure() {
	# use builtin LZMA, linking with p7zip fails
	# use builtin AES, custom implementation
#	local mycmakeargs=(
#		-DSYSTEM_DEPS=ON
#	)
	cmake-utils_src_configure
}

src_install() {
	echo -e "#!/bin/sh\n\ncaesaria.linux -R ${MY_DATADIR}" > caesaria

	dogamesbin caesaria
	dogamesbin ${WORKDIR}/${P}/bin/caesaria.linux

	#dodoc docs/*
	
	dodir ${MY_DATADIR}/resources
	keepdir ${MY_DATADIR}/resources
	
	insinto ${MY_DATADIR}
	doins -r ${WORKDIR}/${P}/bin/resources

	prepgamesdirs
}

pkg_postinst() {
	elog "This ebuild only installs the executable _without_ artwork and"
	elog "other required files for this game. See their homepage"
	elog "${HOMEPAGE}"
	elog "for more information and for instructions how to obtain those"
	elog "files from the official Caesar CD. Then put them into:"
	elog "${MY_DATADIR}/resources/"
}
