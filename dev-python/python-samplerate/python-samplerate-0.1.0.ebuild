EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="This is a wrapper around Erik de Castro Lopo’s libsamplerate (aka Secret Rabbit Code) for high-quality sample rate conversion."
HOMEPAGE="
	https://github.com/tuxu/python-samplerate/
	https://pypi.org/project/samplerate/
"
SRC_URI="
	https://github.com/tuxu/python-samplerate/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

RDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	media-libs/libsamplerate
"
DEPEND="${RDEPEND}"
