# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/2167a4113a08a20682d9bcd98d0648f9ba189754 -> helix-24.07-2167a41.tar.gz
https://distfiles.macaronios.org/19/40/09/19400933e0da7588022a7d00b86fef5f578c766c2f51a86038ebcf990723fb0cec6772b86713ca2f1315452681f9cf4208958e64628744e47cbab81dc75f2006 -> helix-24.07-funtoo-crates-bundle-fc89a04e9d965e55a02510a511b71081d120206b317f00802f8ab0a936a33935da5cc3c7c0585ef07e468b685d534062901fa09283449c79833fd20f41f4faaa.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-2167a41"

src_compile() {
	export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1

	cargo_src_compile
}

src_install() {
	rm -rf ${S}/runtime/grammars/sources

	insinto /usr/share/helix
	doins -r runtime
 
	use doc && dodoc README.md CHANGELOG.md
	use doc && dodoc -r docs/

	cargo_src_install --path helix-term
}

pkg_postinst() {
	elog "You will need to copy /usr/share/helix/runtime into your \$HELIX_RUNTIME"
	elog "For syntax highlighting and other features. "
	elog ""
	elog "Run: "
	elog "cp -r /usr/share/helix/runtime ~/.config/helix/runtime"
	elog ""
	elog "To install tree-sitter grammars for helix run the following:"
	elog "hx -g fetch"
	elog "hx -g build"
}