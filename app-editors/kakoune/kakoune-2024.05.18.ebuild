# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Modal editor inspired by vim"
HOMEPAGE="http://kakoune.org/ https://github.com/mawww/kakoune"
SRC_URI="https://api.github.com/repos/mawww/kakoune/tarball/v2024.05.18 -> kakoune-2024.05.18.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="*"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-enable-ebuild-syntax-highlight.patch
)

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/mawww-kakoune-* ${S} || die
}

src_prepare() {
	sed -i '/CXXFLAGS += -O3/d' src/Makefile || die
	default
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake -C src all
}

src_test() {
	emake -C src test
}

src_install() {
	emake PREFIX="${D}"/usr docdir="${ED}/usr/share/doc/${PF}" install

	rm "${ED}/usr/share/man/man1/kak.1.gz" || die
	doman doc/kak.1
}