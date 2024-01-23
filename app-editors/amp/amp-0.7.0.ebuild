# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/55edadcd7c6856fc19f32cd630a618b0dc7f2bc3 -> amp-0.7.0-55edadc.tar.gz
https://direct.funtoo.org/02/92/e5/0292e56b4693fb033c2095e2ca3174f731ed58d8d4d337501133d53d17b58fb8b4e03cacca203f8c63cecfcb7181024d7d90dd2e368d5a4f7f8918f1a924cee9 -> amp-0.7.0-funtoo-crates-bundle-6f50eb6f737e8070128a8b0d5989788fe04a0a9736096450539bebebab329a44602540480df3221d174ef9de433c9e5e6c1c695fc8ca73e4a2692d30680319f8.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="X"

BDEPEND="
	virtual/rust
	dev-util/cmake
"

RDEPEND="
	dev-vcs/git
	X? ( x11-libs/libxcb )
	dev-libs/openssl
	sys-libs/zlib
"

post_src_unpack() {
	mv ${WORKDIR}/jmacdonald-amp-*/* ${S} || die
}

src_install() {
	cargo_src_install
	dodoc README.md
}