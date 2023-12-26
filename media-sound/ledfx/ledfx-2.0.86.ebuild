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
	dev-python/voluptuous
	dev-python/pybase64
	dev-python/pyserial
	dev-python/zeroconf
	dev-python/aiohttp-cors
	media-libs/aubio[python]
	dev-python/python-samplerate
	dev-python/python-sounddevice
	dev-python/python-rtmidi
	dev-python/openrgb-python
	dev-python/icmplib
	dev-python/sacn
	dev-python/python-osc
	dev-python/flux-led
	dev-python/mss
	dev-python/psutil
	dev-python/paho-mqtt
	dev-python/uvloop
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i '/install_requires/d' "${S}/setup.py"
}
