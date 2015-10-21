# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit  cmake-utils

DESCRIPTION="Cross platform IDE for the C/C++ programming languages"
HOMEPAGE="http://www.codelite.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-gtk.src.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="debug mysql pch postgres"

DEPEND="debug? ( >=x11-libs/wxGTK-2.9.4[debug] )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )"
RDEPEND=">=x11-libs/wxGTK-2.9.4"

