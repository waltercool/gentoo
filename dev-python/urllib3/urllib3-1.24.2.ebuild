# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/shazow/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/ipaddress[${PYTHON_USEDEP}]
	' -2)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/mock[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			>=www-servers/tornado-4.2.1[\${PYTHON_USEDEP}]
		" 'python3*')
	)
"

distutils_enable_sphinx docs \
	dev-python/alabaster \
	dev-python/mock

python_prepare_all() {
	# skip appengine tests
	rm -r test/appengine || die

	distutils-r1_python_prepare_all
}

python_test() {
	# FIXME: get tornado ported
	case ${EPYTHON} in
		python2*)
			ewarn "Tests are being skipped for Python 2 in order to reduce the number"
			ewarn "of circular dependencies for Python 2 removal.  Please test"
			ewarn "manually in a virtualenv."
			;;
		python3*)
			pytest -vv || die "Tests fail with ${EPYTHON}"
			;;
	esac
}
