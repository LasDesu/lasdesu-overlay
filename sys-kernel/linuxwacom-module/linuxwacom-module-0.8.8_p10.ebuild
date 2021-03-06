# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linuxwacom-module/linuxwacom-module-0.8.8_p10.ebuild,v 1.2 2010/11/03 18:26:01 pva Exp $

EAPI="2"
inherit eutils toolchain-funcs linux-mod autotools

# http://who-t.blogspot.com/2010/09/wacom-support-in-linux.html
MY_PN="linuxwacom"
DESCRIPTION="Kernel driver for Wacom tablets and drawing devices"
HOMEPAGE="http://linuxwacom.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-${PV/_p/-}.tar.bz2"

IUSE="usb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="sys-fs/udev
	sys-libs/ncurses"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	usb? ( >=sys-kernel/linux-headers-2.6 )"
S=${WORKDIR}/${MY_PN}-${PV/_p/-}

MODULE_NAMES="wacom(input:${S}/src:${S}/src)"
BUILD_TARGETS="all"

wacom_check() {
	einfo "Checking wacom module not built in kernel"

	if $(linux_chkconfig_present TABLET_USB_WACOM); then
		eerror "Please, disable wacom module in the kernel:"
		eerror
		eerror " Device Drivers"
		eerror "    Input device support"
		eerror "        Tablets"
		eerror "            <> Wacom Intuos/Graphire tablet support (USB)"
		eerror
		eerror '(in the "USB support" page it is suggested to include also:'
		eerror "EHCI , OHCI , USB Human Interface Device+HID input layer)"
		eerror
		eerror "Then recompile kernel."
		die "Wacom module already built in kernel!"
	fi
}

pkg_setup() {
	linux-mod_pkg_setup
	wacom_check
}

src_prepare() {
	if [[ $(gcc-major-version) < 4 || $(gcc-minor-version) < 2 ]]; then
		die "Versions of linuxwacom >= 0.7.9 require gcc >= 4.2 to compile."
	fi
	sed '/WCM_SRC_SUBDIRS=/s: wacomxi util xdrv::' -i configure.in || die

	kernel_is ge 2 6 36 && epatch "${FILESDIR}/linuxwacom-module-2.6.36.patch"
	epatch "${FILESDIR}/linuxwacom-module-3.0.0.patch"
	eautoreconf
}

# TODO: Avoid build of hal (but actually upstream is working on separation of
# modules from linuxwacom so this is really low priority).
src_configure() {
	unset ARCH
	econf \
		--enable-wacom \
		--with-kernel=${KV_OUT_DIR} \
		--disable-dependency-tracking \
		--without-x \
		--disable-xserver64 \
		--without-xlib \
		--without-xorg-sdk \
		--without-tcl \
		--without-tk \
		$(printf -- "--disable-%s " libwacom{cfg,xi} {wac,xi}dump xsetwacom wacomxrrd)
}

src_install() {
	# Inelegant attempt to work around a nasty build system
	cp src/*/wacom.{o,ko} src/ || die
	linux-mod_src_install

	insinto /etc/udev/rules.d/
	doins src/util/60-wacom.rules || die

	exeinto /lib/udev/
	doexe "${FILESDIR}"/check_driver || die
	doman "${FILESDIR}"/check_driver.1

	dodoc AUTHORS ChangeLog
}

pkg_postinst() {
	linux-mod_pkg_postinst
	ewarn "Please remove any HAL .FDI files you may"
	ewarn "previously have installed for linuxwacom."
}
