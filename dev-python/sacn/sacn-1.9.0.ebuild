EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A simple ANSI E1.31 (aka sACN) module for python."
HOMEPAGE="
	https://github.com/Hundemeier/sacn/
	https://pypi.org/project/sacn/
"
SRC_URI="
	https://github.com/Hundemeier/sacn/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
