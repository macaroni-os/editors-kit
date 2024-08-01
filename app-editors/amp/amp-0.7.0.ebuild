# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/55edadcd7c6856fc19f32cd630a618b0dc7f2bc3 -> amp-0.7.0-55edadc.tar.gz
https://distfiles.macaronios.org/16/63/87/16638710bbe442d9c0222e002f885fb4f819aa27a88a6db02189eb42174916b5071a9ba8b4cd429551bc6b26dabc36d0d52d77b79adb6864bbbd2909f06b2fb7 -> amp-0.7.0-funtoo-crates-bundle-6f50eb6f737e8070128a8b0d5989788fe04a0a9736096450539bebebab329a44602540480df3221d174ef9de433c9e5e6c1c695fc8ca73e4a2692d30680319f8.tar.gz"

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