# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-extra-apps/gnome-extra-apps-3.8.0-r1.ebuild,v 1.1 2013/07/20 11:15:00 pacho Exp $

EAPI="5"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE=""

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
RDEPEND="
	>=app-arch/file-roller-${PV}
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gucharmap-${PV}:2.90
	>=gnome-extra/sushi-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
"
# Note: bug-buddy is broken with GNOME 3
# Note: aisleriot-3.4 is masked for guile-2
DEPEND=""
S=${WORKDIR}
