EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="User-mode driver and GTK3 based GUI for Steam Controller"
HOMEPAGE="https://github.com/kozec/sc-controller"

GITHUB_URI="github.com/kozec/sc-controller"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://${GITHUB_URI}.git"
	inherit git-r3
else
	SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""


DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/python-libusb1[${PYTHON_USEDEP}]"

python_prepare_all() {
	#avoid file collisions picked up by the eclass
	sed -e s":find_packages():find_packages(exclude=['tests']):" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover || die "tests failed under ${EPYTHON}"
}
