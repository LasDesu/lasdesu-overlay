# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit eutils cmake-utils wxwidgets fdo-mime gnome2-utils python-r1 flag-o-matic versionator

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

#MY_PV="${PV/_/-}"
#MY_PV0="$(get_version_component_range 1-2)"
MY_PV="4.0.0-rc1"
MY_PV0="4.0"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://launchpad.net/${PN}/${MY_PV0}/${MY_PV}/+download/${MY_P}.tar.xz"

IUSE="dev-doc debug doc examples minimal python nanometr gost sexpr github"

LANGS="bg ca cs de el_GR en es fi fr hu it ja ko nl pl pt ru sl sv zh_CN"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

CDEPEND="x11-libs/wxGTK:3.0[X,opengl]
		media-libs/glew"
DEPEND="${CDEPEND}
	>=dev-util/cmake-2.6.0
	>=dev-libs/boost-1.54[context,python?]
	app-arch/xz-utils
	dev-doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}
	sys-libs/zlib
	sci-electronics/electronics-menu
    !minimal? ( sci-electronics/kicad-library )"
    
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-scripts.patch"
}

src_configure() {
	
	need-wxwidgets unicode

	mycmakeargs="${mycmakeargs}
		-DKICAD_DOCS=/usr/share/doc/${PF}
		-DKICAD_HELP=/usr/share/doc/${PF}
		-DKICAD_CYRILLIC=ON
		-DwxUSE_UNICODE=ON
		-DKICAD_TESTING_VERSION=ON
		-DKICAD_MINIZIP=OFF
		-DKICAD_AUIMANAGER=OFF
		-DKICAD_AUITOOLBAR=OFF
		-DKICAD_SKIP_BOOST=ON
		$(cmake-utils_use gost KICAD_GOST)
		$(cmake-utils_use nanometr USE_PCBNEW_NANOMETRES)
		$(cmake-utils_use sexpr USE_PCBNEW_SEXPR_FILE_FORMAT)
		$(cmake-utils_use github BUILD_GITHUB_PLUGIN)
		$(cmake-utils_use python KICAD_SCRIPTING)
		$(cmake-utils_use python KICAD_SCRIPTING_MODULES)
		$(cmake-utils_use python KICAD_SCRIPTING_WXPYTHON)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all
    if use doc ; then
        cmake-utils_src_compile doxygen-docs
    fi
    if use dev-doc ; then
        cmake-utils_src_compile dev-docs
    fi
}

src_install() {
	cmake-utils_src_install
    
    if use dev-doc ; then
		insinto /usr/share/doc/${PF}
		doins uncrustify.cfg
		cd Documentation
		doins -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/*
        
        docompress -x \
            ${dev_doc}/GUI_Translation_HOWTO.odt \
            ${dev_doc}/notes_about_pcbnew_new_file_format.odt \
            ${dev_doc}/uncrustify.cfg
            ${dev_doc}/file_formats.pdf
	fi

}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

    if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge kicad without the 'minimal' USE flag."
		elog
	fi
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
