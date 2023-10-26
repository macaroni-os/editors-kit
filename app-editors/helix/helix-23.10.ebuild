# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/baf8ea8de3ff9cf8f01278e389c01db4c0d19e00 -> helix-23.10-baf8ea8.tar.gz
https://direct.funtoo.org/78/ee/73/78ee73ac4b7f184f78a73789d3e2dd4e9306e8af26bec122a28a5cdcf72d4f4164cf9b8fae4fbc1ac96967a7115bf00e0e91f8b5e1fe80406c9f49a21319b5c7 -> helix-23.10-funtoo-crates-bundle-26dd90d0fae58af9b8c8cbe369c54ff317dc554e9128b7fa50e05901fd733e63708dbb27364210470ff3b2747de5ce03a4f1cf27c2341ff4cfdf4cc74499dd7f.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-baf8ea8"

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