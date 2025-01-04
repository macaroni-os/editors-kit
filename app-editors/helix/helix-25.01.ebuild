# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A post-modern modal text editor"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="https://github.com/helix-editor/helix/tarball/783134e2a3254490f3610de8fcd372a295027148 -> helix-25.01-783134e.tar.gz
https://distfiles.macaronios.org/35/5c/34/355c34571c25dbae2a5857b8b37ddcd702faebeaf18c6fd2a402b3da6fc4bae91cc6d174e6ab9a274ed7f5165315de776e8d51b401203445443345ab010a76bc -> helix-25.01-funtoo-crates-bundle-e6d52d9c29af461f4902eb41f90cac836fac4fa3a494bf78f5fc3ff83ccaef44cdae23377515c2347370c5bf663539df74acaf84db19ff5aefad9fccdaac321e.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

S="${WORKDIR}/helix-editor-helix-783134e"

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