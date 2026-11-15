# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
LUA_COMPAT=( lua5-1 luajit )
PYTHON_REQ_USE="threads(+)"
USE_RUBY="ruby31"
inherit vim-doc flag-o-matic bash-completion-r1 python-single-r1 lua-single ruby-single desktop xdg-utils

DESCRIPTION="Vim, an improved vi-style text editor"
HOMEPAGE="https://www.vim.org/ https://github.com/vim/vim"
SRC_URI="https://api.github.com/repos/vim/vim/tarball/refs/tags/v9.2.1342 -> vim-9.2.1342-cd50664.tar.gz"
LICENSE="vim"
SLOT="0"
KEYWORDS="*"
IUSE="X acl crypt cscope debug gpm lua minimal nls perl python ruby sound tcl terminal vim-pager"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
python? ( ${PYTHON_REQUIRED_USE} )
vim-pager? ( !minimal )
"
RDEPEND=">=app-eselect/eselect-vi-1.1
	sys-libs/ncurses
	nls? ( virtual/libintl )
	acl? ( sys-apps/acl )
	crypt? ( dev-libs/libsodium:= )
	cscope? ( dev-util/cscope )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	lua? (
	  ${LUA_DEPS}
	  $(lua_gen_impl_dep 'deprecated' lua5-1)
	)
	~app-editors/vim-core-9.2.1342
	vim-pager? ( app-editors/vim-core[-minimal] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
	sound? ( media-libs/libcanberra )
	tcl? ( dev-lang/tcl:0= )
	X? ( x11-libs/libXt )
	
"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	lua? ( ${LUA_DEPS} )
	nls? ( sys-devel/gettext )
	
"
PDEPEND="!minimal? ( app-vim/gentoo-syntax )
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
	sed -i 's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
	"${S}"/runtime/doc/syntax.txt \
	"${S}"/runtime/doc/tagsrch.txt \
	"${S}"/runtime/doc/usr_29.txt \
	"${S}"/runtime/menu.vim \
	"${S}"/src/configure.ac || die 'sed failed'
	# Don't be fooled by /usr/include/libc.h. When found, vim thinks
	# this is NeXT, but it's actually just a file in dev-libs/9libs
	sed -i 's/ libc\.h / /' "${S}"/src/configure.ac || die 'sed failed'
	# Conditionally make the manpager.sh script
	if use vim-pager; then
	cat > "${S}"/runtime/macros/manpager.sh <<-_EOF_ || die "cat EOF failed"
		#!/bin/sh
		sed -e 's/\x1B\[[[:digit:]]\+m//g' | col -b | \\
				vim \\
					-c 'let no_plugin_maps = 1' \\
					-c 'set nolist nomod ft=man ts=8' \\
					-c 'let g:showmarks_enable=0' \\
					-c 'runtime! macros/less.vim' -
	_EOF_
	fi
	# Try to avoid sandbox problems in the po test target.
	if [[ -d "${S}"/src/po ]]; then
	sed -i -e \
		'/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
		"${S}"/src/po/Makefile || die "sed failed"
	fi
	cp "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk || die "Failed to copy config.mk."
	# Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	sed -i "s:\\\$(PERLLIB)/ExtUtils/xsubpp:/usr/bin/xsubpp:" \
	"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'
}

src_configure() {
	# Disallow -funroll-all-loops, it causes problems
	filter-flags -funroll-all-loops
	# -O3 causes problems, use -O2 instead
	replace-flags -O3 -O2
	emake -j1 -C src autoconf
	# This should fix a sandbox violation. The hvc things are for
	# ppc64 consoles.
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc*; do
	if [[ -e "${file}" ]]; then
		addwrite ${file}
	fi
	done
	local myconf=()
	if use minimal ; then
	myconf=(
		--with-features=tiny
		--disable-nls
		--disable-multibyte
		--disable-acl
		--enable-gui=no
		--without-x
		--disable-darwin
		--disable-luainterp
		--disable-perlinterp
		--disable-pythoninterp
		--disable-mzschemeinterp
		--disable-rubyinterp
		--disable-selinux
		--disable-tclinterp
		--disable-gpm
	)
	else
	use debug && append-flags "-DDEBUG"
		myconf=(
		--with-features=huge
		$(use_enable sound canberra)
		$(use_enable acl)
		$(use_enable crypt libsodium)
		$(use_enable cscope)
		$(use_enable gpm)
		$(use_enable nls)
		$(use_enable perl perlinterp)
		$(use_enable python python3interp)
		$(use_with python python3-command "${PYTHON}")
		$(use_enable ruby rubyinterp)
		$(use_enable tcl tclinterp)
		$(use_enable terminal)
	)
		# --with-features=huge forces on cscope even if we --disable it,
	# so sed it out of feature.h to avoid screwiness.
	if ! use cscope ; then
		sed -i '/# define FEAT_CSCOPE/d' src/feature.h || \
		die "couldn't disable cscope"
	fi
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
		# Don't test USE=X here, but provide a way to link against X
	myconf+=(
		--enable-gui=no
		--disable-darwin
		$(use_with X x)
	)
	fi
	# let package manager strip binaries
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"
	econf \
	--with-modified-by=MacaroniOS-9.2.1342 \
	"${myconf[@]}"
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
	local vimfiles=/usr/share/vim/vim92
	# Note: Do not install symlinks for 'vi', 'ex', or 'view', as
	# these are managed by eselect-vi
	dobin src/vim
	if ! use minimal ; then
	dosym vim /usr/bin/vimdiff
	fi
	dosym vim /usr/bin/rvim
	dosym vim /usr/bin/rview
	if use vim-pager ; then
	dosym ${vimfiles}/macros/less.sh /usr/bin/vimpager
	dosym ${vimfiles}/macros/manpager.sh /usr/bin/vimmanpager
	insinto ${vimfiles}/macros
	doins runtime/macros/manpager.sh
	fperms a+x ${vimfiles}/macros/manpager.sh
	fi
	domenu runtime/vim.desktop
	newbashcomp "${FILESDIR}"/vim-completion vim
	# keep in sync with 'complete ... -F' list
	bashcomp_alias vim ex vi view rvim rview vimdiff
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Call eselect vi update
	eselect_vi_update
	# update desktop file mime cache
	xdg_desktop_database_update
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Call eselect vi update
	eselect_vi_update
	# update desktop file mime cache
	xdg_desktop_database_update
}



# vim: filetype=ebuild
