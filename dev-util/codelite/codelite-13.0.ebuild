EAPI=6

WX_GTK_VER="3.0"

inherit cmake-utils xdg-utils wxwidgets

DESCRIPTION="Cross platform IDE for the C/C++ programming languages"
HOMEPAGE="http://www.codelite.org/"
LICENSE="GPL-2"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/eranif/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/eranif/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE="-sftp -lldb php deb +pch"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}
	dev-db/sqlite:3
	sftp? ( net-libs/libssh )
	lldb? ( dev-util/lldb )"
DEPEND="${RDEPEND}"

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
		-DWITH_PCH=$(usex pch 1 0)
		-DENABLE_SFTP=$(usex sftp 1 0)
		-DENABLE_LLDB=$(usex lldb 1 0)
		-DPHP_BUILD=$(usex php 1 0)
		-DMAKE_DEB=$(usex deb 1 0)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
