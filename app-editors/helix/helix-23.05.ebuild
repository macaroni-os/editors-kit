# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/1c7c4baeac5e30b7439889b38477b08089feafb4 -> helix-23.05-1c7c4ba.tar.gz
https://direct.funtoo.org/7a/bd/40/7abd400ec1f50f4481230a8a86e5480ac888259583c33afeb804583eecbba332047e9d070fe6d9263e9503453cac1b6fec8f6241f93cd478cb369ea9fe644564 -> helix-23.05-funtoo-crates-bundle-221af6fa218ad40bc26ec4c46133d08459e28fd0c00b8d9e46e5d2b9ce23861b6b1df2677b43221666d1dbf69e3e7963f4c295300f21108360777f16649b57d9.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-1c7c4ba"

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