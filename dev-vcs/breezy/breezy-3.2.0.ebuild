# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/-${PR}/}"
MY_PV="${MY_PV/_p/-}"
MY_P="${PN}-${MY_PV}"

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} )

inherit distutils-r1 bash-completion-r1 elisp-common

DESCRIPTION="Breezy has built-in support for the Git and Bazaar file formats and network protocols."
HOMEPAGE="https://www.breezy-vcs.org"
SRC_URI="https://github.com/breezy-team/${PN}/archive/brz-${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bash-completion doc emacs gpg sftp test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	!dev-vcs/bzr
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/fastimport-0.9.8[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.19.11[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.24.1[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-epytext[${PYTHON_USEDEP}]
	)
	emacs? ( >=app-editors/emacs-23.1:* )
	gpg? ( dev-python/pyGPG[${PYTHON_USEDEP}] )
	sftp? (
		dev-python/paramiko[${PYTHON_USEDEP}]
		|| (
			dev-python/pycryptodome[${PYTHON_USEDEP}]
			dev-python/pycrypto[${PYTHON_USEDEP}]
		)
	)"

DEPEND="${RDEPEND}
	test? ( >=dev-python/testtools-0.9.5[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${PN}-brz-${MY_PV}

SITEFILE="70${PN}-gentoo.el"

python_prepare_all() {
	# Fix man install location
	sed -r -i.bck "s|['](man/man1)[']|'share/\1'|" "setup.py" || die

	# Prevent un-needed d'loading during doc build
	sed -s -i.bck 's:intersphinx_mapping:_&:' -i "${PN}/doc_generate/conf.py" || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# Fix "loading pickled environment... failed"
		rm -rf "doc/en/_build" || die
		rm -rf "doc/developers/_build" || die

		emake docs

		# Reference the right location of html documents
		sed -r -i.bck 's| doc/(en/release-notes)| html/\1|' "NEWS" || die
	fi

	if use emacs; then
		elisp-compile contrib/emacs/brz-mode.el
	fi
}

python_test() {
	PYTHONPATH="." "${PYTHON}" ./brz selftest -v --strict || die "selftest failed"
}

python_install_all() {
	local DOCS=( COPYING.txt NEWS README.rst TODO )
	local HTML_DOCS=

	if use bash-completion; then
		dobashcomp contrib/bash/brz
		dosym brz $(_bash-completion-r1_get_bashcompdir)/bzr
	fi

	if use doc; then
		local doc

		einfo "Installing user docs ..."
		pushd "doc/en/_build/html" || die
		for doc in $(find . -type f); do
			docinto "html/en/$(dirname ${doc})"
			dodoc "${doc}"
		done
		popd || die

		einfo "Installing developer docs ..."
		pushd "doc/developers/_build/html" || die
		for doc in $(find . -type f); do
			docinto "html/developers/$(dirname ${doc})"
			dodoc "${doc}"
		done
		popd || die
	fi

        if use emacs; then
                elisp-install ${PN} contrib/emacs/brz-mode.{el,elc}
                elisp-site-file-install "${FILESDIR}/${SITEFILE}"
        fi

	dosym brz /usr/bin/bzr
	dosym brz.1 /usr/share/man/man1/bzr.1

	distutils-r1_python_install_all
}

pkg_postinst() {
        use emacs && elisp-site-regen
}

pkg_postrm() {
        use emacs && elisp-site-regen
}
