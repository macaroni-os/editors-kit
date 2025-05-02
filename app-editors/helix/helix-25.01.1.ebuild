# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/60b93dec398b289da148a4716f27843f644122a2 -> helix-25.01.1-60b93de.tar.gz
https://distfiles.macaronios.org/84/7e/7b/847e7b19c8842ab7657ac634c999946722908f576102b5824cf7b4f59088a143ff2320881b285a6603fb787412c3cb91bc6cf179cd3e5d7e38267341b541f439 -> helix-25.01.1-funtoo-crates-bundle-5dba7b6dd80178e997100642a7a03edd9ba030faa723c852f51c57b98078d2452e206decb582f6f79bd9905be1f63190c93857f753d05330007e94399c73a419.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-60b93de"

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