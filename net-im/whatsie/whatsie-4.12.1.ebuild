EAPI=7

inherit desktop qmake-utils

DESCRIPTION="Qt Based WhatsApp Client"
HOMEPAGE="https://github.com/keshavbhatt/whatsie"
SRC_URI="https://github.com/keshavbhatt/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtwebengine:5
	dev-qt/qtpositioning:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	#dobin ${PN}
	#doicon extra/${PN}.png
	#domenu extra/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
