# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/55edadcd7c6856fc19f32cd630a618b0dc7f2bc3 -> amp-0.7.0-55edadc.tar.gz
https://distfiles.macaronios.org/3d/af/ef/3dafefa16cb458e07d7975124a2dc87dfa7e58a8b6261eea5663d1a18e74a57ab9ffa7444d86fc8502fe7e038310de8b3da13a8d1226f1e69b322bd58fb34b29 -> amp-0.7.0-funtoo-crates-bundle-6f50eb6f737e8070128a8b0d5989788fe04a0a9736096450539bebebab329a44602540480df3221d174ef9de433c9e5e6c1c695fc8ca73e4a2692d30680319f8.tar.gz"

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