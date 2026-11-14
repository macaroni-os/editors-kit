# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
LUA_COMPAT=( lua5-1 luajit )
PYTHON_REQ_USE="threads(+)"
USE_RUBY="ruby31"
inherit bash-completion-r1 flag-o-matic lua-single python-single-r1 ruby-single vim-doc xdg-utils

DESCRIPTION="GUI version of the Vim text editor"
HOMEPAGE="https://www.vim.org/ https://github.com/vim/vim"
SRC_URI="https://api.github.com/repos/vim/vim/tarball/refs/tags/v9.2.1342 -> gvim-9.2.1342-cd50664.tar.gz"
LICENSE="vim"
SLOT="0"
KEYWORDS="*"
IUSE="acl crypt cscope debug lua minimal netbeans nls perl python ruby session sound tcl"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
python? ( ${PYTHON_REQUIRED_USE} )
"
BDEPEND="sys-devel/autoconf
	virtual/pkgconfig
	lua? ( ${LUA_DEPS} )
	nls? ( sys-devel/gettext )
	
"
RDEPEND="~app-editors/vim-core-9.2.1342
	>=app-eselect/eselect-vi-1.1
	sys-libs/ncurses
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXt
	acl? ( sys-apps/acl )
	x11-libs/gtk+:3
	x11-libs/libXft
	crypt? ( dev-libs/libsodium:= )
	cscope? ( dev-util/cscope )
	lua? (
	  ${LUA_DEPS}
	  $(lua_gen_impl_dep 'deprecated' lua5-1)
	)
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
	sound? ( media-libs/libcanberra )
	tcl? ( dev-lang/tcl:0= )
	
"
DEPEND="${RDEPEND}
"

post_src_unpack() {
	mv vim-vim-* ${S}
}


pkg_setup() {
	# People with broken alphabets run into trouble.
	unset LANG LC_ALL
	export LC_COLLATE="C"
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	# Fix up a script to use awk instead of nawk
	sed -i -e '1s|.*|#!/usr/bin/awk -f|' \
	"${S}"/runtime/tools/mve.awk || die "mve.awk sed failed"
	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "/etc/vim/vimrc"' \
	>> "${S}"/src/feature.h || die "echo failed"
	echo '#define SYS_GVIMRC_FILE "/etc/vim/gvimrc"' \
	>> "${S}"/src/feature.h || die "echo failed"
	# Use exuberant ctags which installs as /usr/bin/exuberant-ctags.
	# Hopefully this pattern won't break for a while at least.
	sed -i -e \
	's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
	"${S}"/runtime/doc/syntax.txt \
	"${S}"/runtime/doc/tagsrch.txt \
	"${S}"/runtime/doc/usr_29.txt \
	"${S}"/runtime/menu.vim \
	"${S}"/src/configure.ac || die 'sed failed'
	# Don't be fooled by /usr/include/libc.h. When found, vim thinks
	# this is NeXT, but it's actually just a file in dev-libs/9libs
	sed -i -e \
	's/ libc\.h / /' "${S}"/src/configure.ac || die 'sed failed'
	# Try to avoid sandbox problems in the po test target.
	if [[ -d "${S}"/src/po ]]; then
	sed -i -e \
		'/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
		"${S}"/src/po/Makefile || die
	fi
	cp -v "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk || die "Failed to copy config.mk."
	# Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	sed -i -e \
	"s:\\\$(PERLLIB)/ExtUtils/xsubpp:/usr/bin/xsubpp:" \
	"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'
	# Prevent "make" from the following chain:
	# (1) Notice configure.ac is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i -e \
	's# auto/config\.mk:#:#' src/Makefile || die "Makefile sed failed"
	rm -v src/auto/configure || die "rm failed"
	# --with-features=huge forces on cscope even if we --disable it,
	# so sed it out of feature.h to avoid screwiness.
	if ! use cscope; then
	sed -i -e \
		'/# define FEAT_CSCOPE/d' src/feature.h || die "couldn't disable cscope"
	fi
}

src_configure() {
	# Disallow -funroll-all-loops, it causes problems
	filter-flags -funroll-all-loops
	# -O3 causes problems, use -O2 instead
	replace-flags -O3 -O2
	emake -j1 -C src autoconf
	# This should fix a sandbox violation. The hvc things are for
	# ppc64 consoles.
	local file
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc*; do
	if [[ -e ${file} ]]; then
		addwrite $file
	fi
	done
	use debug && append-flags "-DDEBUG"
	local myconf=(
	--with-features=huge
	--disable-gpm
	--with-gnome=no
	$(use_enable sound canberra)
	$(use_enable acl)
	$(use_enable crypt libsodium)
	$(use_enable cscope)
	$(use_enable netbeans)
	$(use_enable nls)
	$(use_enable perl perlinterp)
	$(use_enable python python3interp)
	$(use_with python python3-command "${PYTHON}")
	$(use_enable ruby rubyinterp)
	$(use_enable session xsmp)
	$(use_enable tcl tclinterp)
	--enable-gtk3-check
	--enable-gui=gtk3
	--with-x
	--with-vim-name=gvim
	--with-modified-by=MacaroniOS-9.2.1342
	)
	if use lua; then
	# -DLUA_COMPAT_OPENLIB=1 is required to enable the
	# luaL_openlib API deprecated in lua 5.1
	use lua_single_target_lua5-1 && append-cppflags -DLUA_COMPAT_OPENLIB=1
		myconf+=(
		--enable-luainterp
		$(use_with lua_single_target_luajit luajit)
		--with-lua-prefix="/usr"
	)
	fi
	# let package manager strip binaries
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"
	econf "${myconf[@]}"
}

src_compile() {
	# The following allows emake to be used
	emake -j1 -C src auto/osdef.h objects
	emake
}

# Call eselect vi update with --if-unset to respect user's choice
eselect_vi_update() {
	ebegin "Calling eselect vi update"
	eselect vi update --if-unset
	eend $?
}

src_install() {
	dobin src/gvim
	dosym gvim /usr/bin/gvimdiff
	dosym gvim /usr/bin/evim
	dosym gvim /usr/bin/eview
	dosym gvim /usr/bin/gview
	dosym gvim /usr/bin/rgvim
	dosym gvim /usr/bin/rgview
	emake -C src DESTDIR="${D}" DATADIR=/usr/share install-icons
	dodir /usr/share/man/man1
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gvim.1 || die "echo failed"
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gview.1 || die "echo failed"
	echo ".so vimdiff.1" > "${ED}"/usr/share/man/man1/gvimdiff.1 || die "echo failed"
	insinto /etc/vim
	newins "${FILESDIR}"/gvimrc-r1 gvimrc
	# Bash completion script
	newbashcomp "${FILESDIR}"/gvim-completion gvim
	bashcomp_alias gvim gvimdiff
	bashcomp_alias gvim evim
	bashcomp_alias gvim eview
	bashcomp_alias gvim gview
	bashcomp_alias gvim rgvim
	bashcomp_alias gvim rgview
	# Don't install the vim desktop file, gvim ships its own
	rm -v "${ED}"/usr/share/applications/vim.desktop || die "failed to remove vim.desktop"
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Update fdo mime stuff
	xdg_desktop_database_update
	# Update icon cache
	xdg_icon_cache_update
	# Call eselect vi update
	eselect_vi_update
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Update fdo mime stuff
	xdg_desktop_database_update
	# Update icon cache
	xdg_icon_cache_update
	# Call eselect vi update
	eselect_vi_update
}



# vim: filetype=ebuild
