# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils gnome2 versionator

DESCRIPTION="Unity greeter for LightDM"
HOMEPAGE="https://launchpad.net/unity-greeter"
SRC_URI="https://launchpad.net/unity-greeter/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libindicator:3
	dev-lang/vala:0.18
	>=dev-libs/atk-1.12.4
	>=sys-libs/glibc-2.4
	>=x11-libs/cairo-1.2.4
	>=x11-libs/gdk-pixbuf-2.22.0
	>=dev-libs/glib-2.26.0
	x11-libs/gtk+:3
	>=x11-libs/pango-1.14.0
	x11-libs/libX11
	app-accessibility/at-spi2-core
	>=gnome-base/gnome-settings-daemon-3.2.3
	>=x11-misc/lightdm-0.9.2"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV}-fix-at-spi-bus-launcher.patch
	epatch "${FILESDIR}"/${PN}-${PV}-valac-18.patch
}


pkg_postinst() {
	gnome2_pkg_postinst
	elog
	elog "Use dconf-editor to change settings on"
	elog " com.cannonical.unity-greeter"
	elog
}
