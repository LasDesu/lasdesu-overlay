EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="OpenRGB-Python is a client for the OpenRGB SDK, a manufacturer-independent, cross-platform way to control your RGB devices."
HOMEPAGE="
	https://github.com/jath03/openrgb-python/
	https://pypi.org/project/openrgb-python/
"
SRC_URI="
	https://github.com/jath03/openrgb-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

RDEPEND="
	app-misc/openrgb
"
DEPEND="${RDEPEND}"
