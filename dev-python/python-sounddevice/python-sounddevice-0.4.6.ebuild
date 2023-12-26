EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="This Python module provides bindings for the PortAudio library and a few convenience functions to play and record NumPy arrays containing audio signals."
HOMEPAGE="
	https://github.com/spatialaudio/python-sounddevice/
	https://pypi.org/project/sounddevice/
"
SRC_URI="
	https://github.com/spatialaudio/python-sounddevice/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

RDEPEND="
	media-libs/portaudio
"
DEPEND="${RDEPEND}"
