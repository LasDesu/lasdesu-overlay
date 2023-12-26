EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_PN="${PN//-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python library to communicate with the flux_led smart bulbs"
HOMEPAGE="
	https://github.com/Danielhiversen/flux_led/
	https://pypi.org/project/flux-led/
"
SRC_URI="
	https://github.com/Danielhiversen/flux_led/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/webcolors
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_P}"
