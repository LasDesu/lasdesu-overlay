EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="icmplib is a brand new and modern implementation of the ICMP protocol in Python."
HOMEPAGE="
	https://github.com/ValentinBELYN/icmplib/
	https://pypi.org/project/icmplib/
"
SRC_URI="
	https://github.com/ValentinBELYN/icmplib/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

#RDEPEND=""
#DEPEND="${RDEPEND}"
