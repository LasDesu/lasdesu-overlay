# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/love/love-0.8.0.ebuild,v 1.9 2013/07/30 14:26:40 pinkbyte Exp $

EAPI=5

inherit eutils fdo-mime gnome2-utils games

if [[ ${PV} == 9999* ]]; then
	inherit autotools mercurial
	EHG_REPO_URI="https://bitbucket.org/rude/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://bitbucket.org/rude/${PN}/downloads/${P}-linux-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"

LICENSE="ZLIB"
SLOT="0"
IUSE="luajit"

RDEPEND="dev-games/physfs
	media-libs/devil[mng,png,tiff]
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl2[joystick,opengl]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl
	luajit? ( dev-lang/luajit )
	!luajit? ( dev-lang/lua[deprecated] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "readme.md" "changes.txt" )

src_prepare() {
	if [[ ${PV} == 9999* ]]; then
		sh platform/unix/gen-makefile || die
		mkdir platform/unix/m4 || die
		eautoreconf
	fi
}

src_configure() {
	local my_conf

	if [[ "${SLOT}" != "0" ]]; then
		my_conf="--enable-static --disable-shared"
	fi

	egamesconf \
		--with-lua=$(usex luajit "luajit" "lua") \
		${my_conf}
}

src_install() {
	if [[ "${SLOT}" != "0" ]]; then
		newgamesbin src/${PN} ${PN}-${SLOT}
		dodoc ${DOCS[@]}
	else
		default
		prune_libtool_files
	fi
}

pkg_preinst() {
	games_pkg_preinst
	if [[ "${SLOT}" != "0" ]]; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	games_pkg_postinst
	if [[ "${SLOT}" != "0" ]]; then
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	if [[ "${SLOT}" != "0" ]]; then
		fdo-mime_desktop_database_update
		fdo-mime_mime_database_update
		gnome2_icon_cache_update
	fi
}
