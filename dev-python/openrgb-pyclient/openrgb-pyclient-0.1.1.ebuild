EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python client for OpenRGBs new server."
HOMEPAGE="
	https://github.com/bahorn/OpenRGB-PyClient/
	https://pypi.org/project/OpenRGB-PyClient/
"
SRC_URI="
	https://github.com/bahorn/OpenRGB-PyClient/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

RDEPEND="
	app-misc/openrgb
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/OpenRGB-PyClient-${PV}"

python_compile() {
	GITHUB_REF="v${PV}" distutils-r1_python_compile
}
