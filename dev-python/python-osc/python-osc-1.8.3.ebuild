EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Open Sound Control server and client implementations in pure Python"
HOMEPAGE="
	https://github.com/attwad/python-osc/
	https://pypi.org/project/python-osc/
"
SRC_URI="
	https://github.com/attwad/python-osc/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

src_configure() {
	echo "" >> pyproject.toml
	echo "[build-system]" >> pyproject.toml
	echo "build-backend = \"setuptools.build_meta\"" >> pyproject.toml
}
