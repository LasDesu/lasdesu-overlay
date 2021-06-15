# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit python-r1

DESCRIPTION="Virtual for Bazaar distributed version control system"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	|| (
		dev-vcs/breezy[${PYTHON_USEDEP}]
		dev-vcs/bzr[${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}"
