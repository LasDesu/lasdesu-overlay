EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_PN="LedFx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="LedFx is a network based LED effect controller with support for advanced real-time audio effects! LedFx can control multiple devices and works great with cheap ESP8266 nodes allowing for cost effective synchronized effects across your entire house!

."
HOMEPAGE="
	https://github.com/LedFx/LedFx/
	https://pypi.org/project/ledfx/
"
SRC_URI="
	https://github.com/LedFx/LedFx/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest

RDEPEND="
	dev-python/voluptuous[${PYTHON_USEDEP}]
	dev-python/pybase64[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/zeroconf[${PYTHON_USEDEP}]
	dev-python/aiohttp-cors[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-libs/aubio[python]
	dev-python/python-samplerate[${PYTHON_USEDEP}]
	dev-python/python-sounddevice[${PYTHON_USEDEP}]
	dev-python/python-rtmidi[${PYTHON_USEDEP}]
	dev-python/openrgb-python[${PYTHON_USEDEP}]
	dev-python/icmplib[${PYTHON_USEDEP}]
	dev-python/sacn[${PYTHON_USEDEP}]
	dev-python/python-osc[${PYTHON_USEDEP}]
	dev-python/flux-led[${PYTHON_USEDEP}]
	dev-python/mss[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/paho-mqtt[${PYTHON_USEDEP}]
	dev-python/uvloop[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i '/install_requires/d' "${S}/setup.py"
}
