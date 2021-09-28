# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Vim-fork focused on extensibility and agility."
HOMEPAGE="https://neovim.io"
SRC_URI="https://github.com/neovim/neovim/archive/ec4731d982031e363a59efd4566fc72234bb43c8.tar.gz -> neovim-20210928.tar.gz"
KEYWORDS=""

LICENSE="Apache-2.0 vim"
SLOT="0"
IUSE="+lto +luajit +nvimpager +tui"

BDEPEND="
	dev-util/gperf
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
"
DEPEND="
	dev-libs/libuv:0=
	dev-libs/libvterm:0=
	dev-libs/msgpack:0=
	dev-lua/lpeg[luajit=]
	dev-lua/luv[luajit=]
	dev-lua/mpack[luajit=]
	net-libs/libnsl
	dev-libs/tree-sitter
	luajit? ( dev-lang/luajit:2 )
	!luajit? (
		dev-lang/lua:=
		dev-lua/LuaBitOp
	)
	tui? (
		dev-libs/libtermkey
		>=dev-libs/unibilium-2.0.0:0=
	)
"
RDEPEND="
	${DEPEND}
	app-eselect/eselect-vi
"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/neovim-* "${S}"
}

src_prepare() {
	# use our system vim dir
	sed -e "/^# define SYS_VIMRC_FILE/s|\$VIM|${EPREFIX}/etc/vim|" \
		-i src/nvim/globals.h || die

	cmake_src_prepare
}

src_configure() {
	# Upstream default to LTO on non-debug builds
	# Let's expose it as a USE flag because upstream
	# have preferences for how we should use LTO
	# if we want it on (not just -flto)
	# ... but allow turning it off.
	local mycmakeargs=(
		-DENABLE_LTO=$(usex lto)
		-DFEAT_TUI=$(usex tui)
		-DPREFER_LUA=$(usex luajit no yes)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# install a default configuration file
	insinto /etc/vim
	doins "${FILESDIR}"/sysinit.vim

	# conditionally install a symlink for nvimpager
	if use nvimpager; then
		dosym ../share/nvim/runtime/macros/less.sh /usr/bin/nvimpager
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "clipboard support" x11-misc/xsel x11-misc/xclip gui-apps/wl-clipboard
	elog "Python plugin support" dev-python/pynvim
	elog "Ruby plugin support" dev-ruby/neovim-ruby-client
	elog "remote/nvr support" dev-python/neovim-remote
}