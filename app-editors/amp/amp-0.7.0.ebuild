# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A complete text editor for your terminal"
HOMEPAGE="https://github.com/jmacdonald/amp"
SRC_URI="https://github.com/jmacdonald/amp/tarball/55edadcd7c6856fc19f32cd630a618b0dc7f2bc3 -> amp-0.7.0-55edadc.tar.gz
https://distfiles.macaronios.org/e6/ec/55/e6ec55770070699a57d0da5d69f3277e4d5b8e7de6dab5c52b03686f84807ce9a8fd75918452b28e92a65c69b4442bafcc882a1d6e322fac8e3ab68d27819768 -> amp-0.7.0-funtoo-crates-bundle-6f50eb6f737e8070128a8b0d5989788fe04a0a9736096450539bebebab329a44602540480df3221d174ef9de433c9e5e6c1c695fc8ca73e4a2692d30680319f8.tar.gz"

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