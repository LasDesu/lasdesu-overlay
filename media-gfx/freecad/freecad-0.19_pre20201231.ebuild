# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit check-reqs cmake desktop optfeature python-single-r1 xdg

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="https://www.freecadweb.org/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeCAD/FreeCAD.git"
else
	COMMIT=82ec99dbc1f0f054748059ae8bb138eb44b43073
	SRC_URI="https://github.com/FreeCAD/FreeCAD/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="ccache debug headless oce pcl test webkit webengine"
RESTRICT="!test? ( test )"
REQUIRED_USE="?? ( webkit webengine )"

FREECAD_EXPERIMENTAL_MODULES="cloud plot ship"
FREECAD_DEBUG_MODULES="sandbox template"
FREECAD_STABLE_MODULES="addonmgr arch drawing fem idf image
	inspection material mesh openscad part-design path points
	raytracing robot show spreadsheet surface techdraw tux"
FREECAD_DISABLED_MODULES="vr"
FREECAD_ALL_MODULES="${FREECAD_STABLE_MODULES}
	${FREECAD_EXPERIMENTAL_MODULES} ${FREECAD_DISABLED_MODULES}"

for module in ${FREECAD_STABLE_MODULES}; do
	IUSE="${IUSE} +${module}"
done
for module in ${FREECAD_EXPERIMENTAL_MODULES}; do
	IUSE="${IUSE} -${module}"
done
unset module

RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/eigen-3.3.1:3
	dev-libs/OpenNI2[opengl(+)]
	dev-libs/libspnav[X]
	dev-libs/xerces-c
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	webkit? ( dev-qt/qtwebkit:5 )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	>=media-libs/coin-4.0.0
	media-libs/freetype
	media-libs/qhull
	sci-libs/flann[openmp]
	>=sci-libs/med-4.0.0-r1[python,${PYTHON_SINGLE_USEDEP}]
	sci-libs/orocos_kdl:=
	sys-libs/zlib
	virtual/glu
	virtual/libusb:1
	virtual/opengl
	cloud? (
		dev-libs/openssl:=
		net-misc/curl
	)
	fem? ( <sci-libs/vtk-9[boost,python,qt5,rendering,${PYTHON_SINGLE_USEDEP}] )
	mesh? ( sci-libs/hdf5:=[fortran,zlib] )
	oce? ( sci-libs/oce[vtk(+)] )
	!oce? ( sci-libs/opencascade:=[vtk(+)] )
	openscad? ( media-gfx/openscad )
	pcl? ( >=sci-libs/pcl-1.8.1:=[opengl,openni2(+),qt5(+),vtk(+)] )
	$(python_gen_cond_dep '
		dev-libs/boost:=[python,threads,${PYTHON_MULTI_USEDEP}]
		dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pivy-0.6.5[${PYTHON_MULTI_USEDEP}]
		dev-python/pyside2[gui,svg,${PYTHON_MULTI_USEDEP}]
		dev-python/shiboken2[${PYTHON_MULTI_USEDEP}]
		addonmgr? ( dev-python/GitPython[${PYTHON_MULTI_USEDEP}] )
		mesh? ( dev-python/pybind11[${PYTHON_MULTI_USEDEP}] )
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	ccache? ( dev-util/ccache )
"

# To get required dependencies:
# 'grep REQUIRES_MODS cMake/FreeCAD_Helpers/CheckInterModuleDependencies.cmake'
# We set the following requirements by default:
# draft, import, part, qt5, sketcher, start, web.
#
# Additionally if mesh is set, we auto-enable mesh_part, flat_mesh and smesh
# Fem actually needs smesh, but as long as we don't have a smesh package, we enable
# smesh through the mesh USE flag. Note however, the fem<-smesh dependency isn't
# reflected by the REQUIRES_MODS macro, but at
# cMake/FreeCAD_Helpers/InitializeFreeCADBuildOptions.cmake:187.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	arch? ( mesh )
	debug? ( mesh )
	drawing? ( spreadsheet )
	fem? ( mesh )
	inspection? ( mesh points )
	openscad? ( mesh )
	path? ( mesh robot )
	ship? ( image plot )
	techdraw? ( spreadsheet drawing )
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-FindCoin3DDoc.cmake-fix-patch-for-coin-docs.patch
	"${FILESDIR}"/${P}-0002-CMakeLists.txt-add-option-for-ccache.patch
)

DOCS=( README.md ChangeLog.txt CODE_OF_CONDUCT.md )

CHECKREQS_DISK_BUILD="7G"

[[ ${PV} == *9999 ]] && S="${WORKDIR}/freecad-${PV}" || S="${WORKDIR}/FreeCAD-${COMMIT}"

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
	if ! use oce; then
		[[ -z ${CASROOT} ]] && die "\${CASROOT} not set, plesae run eselect opencascade"
	fi
}

src_prepare() {
	# the upstream provided file doesn't find coin, but cmake ships
	# a working one, so we use this.
	rm "${S}/cMake/FindCoin3D.cmake" || die

	# Fix OpenCASCADE lookup
	sed -e 's|/usr/include/opencascade|${CASROOT}/include/opencascade|' \
		-e 's|/usr/lib|${CASROOT}/'$(get_libdir)' NO_DEFAULT_PATH|' \
		-i cMake/FindOpenCasCade.cmake || die

	# Fix desktop file
	sed -e 's/Exec=FreeCAD/Exec=freecad/' -i src/XDGData/org.freecadweb.FreeCAD.desktop || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ARCH=$(usex arch)
		-DBUILD_ASSEMBLY=OFF
		-DBUILD_CLOUD=$(usex cloud)
		-DBUILD_COMPLETE=OFF # deprecated
		-DBUILD_DRAFT=ON # basic workspace, enable it by default
		-DBUILD_DRAWING=$(usex drawing)
		-DBUILD_ENABLE_CXX_STD:STRING="C++14"	# needed for >=boost-1.75.0
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=OFF
		-DBUILD_FLAT_MESH=$(usex mesh)
		-DBUILD_FORCE_DIRECTORY=ON  # force building in a dedicated directory
		-DBUILD_FREETYPE=ON # automagic dep
		-DBUILD_GUI=$(usex !headless)
		-DBUILD_IDF=$(usex idf)
		-DBUILD_IMAGE=$(usex image)
		-DBUILD_IMPORT=ON # import module for various file formats
		-DBUILD_INSPECTION=$(usex inspection)
		-DBUILD_JTREADER=OFF # code has been removed upstream, but option is still there
		-DBUILD_MATERIAL=$(usex material)
		-DBUILD_MESH=$(usex mesh)
		-DBUILD_MESH_PART=$(usex mesh)
		-DBUILD_OPENSCAD=$(usex openscad)
		-DBUILD_PART=ON # basic workspace, enable it by default
		-DBUILD_PART_DESIGN=$(usex part-design)
		-DBUILD_PATH=$(usex path)
		-DBUILD_PLOT=$(usex plot) # conflicts with possible external workbench
		-DBUILD_POINTS=$(usex points)
		-DBUILD_QT5=ON # OFF means to use Qt4
		-DBUILD_RAYTRACING=$(usex raytracing)
		-DBUILD_REVERSEENGINEERING=OFF # currently only an empty sandbox
		-DBUILD_ROBOT=$(usex robot)
		-DBUILD_SHIP=$(usex ship) # conflicts with possible external workbench
		-DBUILD_SHOW=$(usex show)
		-DBUILD_SKETCHER=ON # needed by draft workspace
		-DBUILD_SMESH=$(usex mesh)
		-DBUILD_SPREADSHEET=$(usex spreadsheet)
		-DBUILD_START=ON # basic workspace, enable it by default
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TUX=$(usex tux)
		-DBUILD_VR=OFF
		-DBUILD_WITH_CONDA=OFF

		-DCMAKE_INSTALL_DATADIR=/usr/share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}

		-DFREECAD_BUILD_DEBIAN=OFF

		-DFREECAD_USE_CCACHE=$(usex ccache)
		-DFREECAD_USE_EXTERNAL_KDL=ON
		-DFREECAD_USE_EXTERNAL_SMESH=OFF # no package in Gentoo
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF # doesn't work yet, also no package in Gentoo tree
		-DFREECAD_USE_FREETYPE=ON
		-DFREECAD_USE_PCL=$(usex pcl)
		-DFREECAD_USE_PYBIND11=$(usex mesh)
		-DFREECAD_USE_QT_FILEDIALOG=ON

		-DOCCT_CMAKE_FALLBACK=ON # don't use occt-config which isn't included in opencascade for Gentoo
	)

	if use oce; then
		mycmakeargs+=(
			-DFREECAD_USE_OCC_VARIANT:STRING="Community Edition"
			-DOCC_INCLUDE_DIR=/usr/include/oce
			-DOCC_LIBRARY_DIR=/usr/$(get_libdir)
		)
	else
		mycmakeargs+=(
			-DFREECAD_USE_OCC_VARIANT:STRING="Official Version"
			-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
			-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)
		)
	fi
	
	if use webkit; then
		mycmakeargs+=(
			-DBUILD_WEB=ON
			-DFREECAD_USE_QTWEBMODULE:STRING="Qt Webkit"
		)
	elif use webengine; then
		mycmakeargs+=(
			-DBUILD_WEB=ON
			-DFREECAD_USE_QTWEBMODULE:STRING="Qt WebEngine"
		)
	else
		mycmakeargs+=(
			-DBUILD_WEB=OFF
		)
	fi

	if use debug; then
		mycmakeargs+=(
			# sandbox needs mesh support
			-DBUILD_SANDBOX=$(usex mesh)
			-DBUILD_TEMPLATE=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_SANDBOX=OFF
			-DBUILD_TEMPLATE=OFF
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DBUILD_TEST=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_TEST=OFF
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if ! use headless; then
		dosym ../$(get_libdir)/${PN}/bin/FreeCAD /usr/bin/freecad
	fi
	dosym ../$(get_libdir)/${PN}/bin/FreeCADCmd /usr/bin/freecadcmd

	if ! use headless; then
		mv "${ED}"/usr/$(get_libdir)/freecad/share/* "${ED}"/usr/share || die "failed to move shared ressources"
	fi

	python_optimize "${ED}"/usr/share/${PN}/data/Mod/ "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
}

pkg_postinst() {
	xdg_pkg_postinst

	if use plot; then
		einfo "Note: You are enabling the 'plot' USE flag."
		einfo "This conflicts with the plot workbench that can be loaded"
		einfo "via the addon manager! You can only install one of those."
	fi

	if use ship; then
		einfo "Note: You are enabling the 'ship' USE flag."
		einfo "This conflicts with the ship workbench that can be loaded"
		einfo "via the addon manager! You can only install one of those."
	fi

	einfo "You can load a lot of additional workbenches using the integrated"
	einfo "AddonManager."

	einfo "There are a lot of additional tools, for which FreeCAD has builtin"
	einfo "support. Some of them are available in Gentoo. Take a look at"
	einfo "https://wiki.freecadweb.org/Installing#External_software_supported_by_FreeCAD"
	optfeature "dependency graphs" media-gfx/graphviz
	optfeature "CSG editor" media-gfx/openscad
	optfeature "interact with git repositories" dev-python/GitPython
	optfeature "FEM mesh generator" sci-libs/gmsh
	optfeature "work with COLLADA documents" dev-python/pycollada
	optfeature "PBR Rendering" media-gfx/povray
}

pkg_postrm() {
	xdg_pkg_postrm
}

# TODO:
# - mirror or update vtk to support py-3.9
# - mirror assembly-4.0 workbench for re-enabling
#		-DBUILD_ASSEMBLY=$(usex assembly)	# currently outdated, updated version not stable
# - netgen needs updating of python support (currently only 3.6 supported)
#	netgen? ( >=sci-mathematics/netgen-6.2.1810[python,opencascade,${PYTHON_SINGLE_USEDEP}] )
#	netgen? ( fem )
#		-DBUILD_FEM_NETGEN=$(usex netgen)
# - test -DINSTALL_TO_SITEPACKAGES: only freecad/__init__.py got installed, test whether this works
#		-DINSTALL_TO_SITEPACKAGES=ON # FIXME: test and implement installing python modules into site-packages
# - add zipios++ package and externalize
# - add smesh package and externalize
