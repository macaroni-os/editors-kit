# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
inherit bash-completion-r1 desktop flag-o-matic vim-doc xdg-utils

DESCRIPTION="Vim and GVim shared files"
HOMEPAGE="https://www.vim.org/ https://github.com/vim/vim"
SRC_URI="https://api.github.com/repos/vim/vim/tarball/refs/tags/v9.2.1342 -> vim-core-9.2.1342-cd50664.tar.gz"
LICENSE="vim"
SLOT="0"
KEYWORDS="*"
IUSE="nls acl minimal"
BDEPEND="sys-devel/autoconf
"
DEPEND="sys-libs/ncurses
"

post_src_unpack() {
	mv vim-vim-* ${S}
}


pkg_setup() {
	# People with broken alphabets run into trouble.
	unset LANG LC_ALL
	export LC_COLLATE="C"
}

src_prepare() {
	default
	# Fix up a script to use awk instead of nawk
	sed -i \
	-e '1s|.*|#!/usr/bin/awk -f|' \
	"${S}"/runtime/tools/mve.awk || die "sed failed"
	# Remove the vimspell helper after tarball extraction
	rm -v "${S}"/runtime/tools/vimspell.sh || die "rm failed"
	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "/etc/vim/vimrc"' >> "${S}"/src/feature.h
	echo '#define SYS_GVIMRC_FILE "/etc/vim/gvimrc"' >> "${S}"/src/feature.h
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
	# Try to avoid sandbox problems in the po test target.
	if [[ -d "${S}"/src/po ]] ; then
	sed -i -e \
		'/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
		"${S}"/src/po/Makefile
	fi
	cp "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk || die "Failed to copy config.mk"
	# Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	sed -i "s:\\\$(PERLLIB)/ExtUtils/xsubpp:/usr/bin/xsubpp:" \
	"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'
	# -O3 causes problems, use -O2 instead
	replace-flags -O3 -O2
	# Prevent "make" from the following chain:
	# (1) Notice configure.ac is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i 's# auto/config\.mk:#:#' src/Makefile || die "Makefile sed failed"
	# Remove the src/auto/configure file
	rm -v src/auto/configure || die "rm configure failed"
}

src_configure() {
	# Disallow -funroll-all-loops, it causes problems
	filter-flags -funroll-all-loops
	emake -j1 -C src autoconf
	# This should fix a sandbox violation. The hvc things are for
	# ppc64 consoles.
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc*; do
	if [[ -e "${file}" ]]; then
		addwrite ${file}
	fi
	done
	# Let Portage do the stripping. Some people like that.
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"
	local myconf=(
	--with-modified-by=MacaroniOS-9.2.1342
	--enable-gui=no
	--without-x
	--disable-darwin
	--disable-perlinterp
	--disable-pythoninterp
	--disable-rubyinterp
	--disable-gpm
	--disable-selinux
	$(use_enable nls)
	$(use_enable acl)
	)
	econf "${myconf[@]}"
}

src_compile() {
	# The following allows emake to be used
	emake -j1 -C src auto/osdef.h objects
	emake tools
}

src_install() {
	local vimfiles=/usr/share/vim/vim92
	dodir /usr/{bin,share/{man/man1,vim}}
	emake -C src \
	installruntime \
	installmanlinks \
	installmacros \
	installtutor \
	installtutorbin \
	installtools \
	install-languages \
	DESTDIR="${D}" \
	BINDIR=/usr/bin \
	MANDIR=/usr/share/man \
	DATADIR=/usr/share
	keepdir ${vimfiles}/keymap
	# The default vimrc is installed by vim-core since it applies
	# to both vim and gvim
	insinto /etc/vim/
	newins "${FILESDIR}"/vimrc-r1 vimrc
	if use minimal ; then
	# To save space, install only a subset of the files.
	rm -rv "${ED}${vimfiles}"/{compiler,doc,ftplugin,indent} || die
	rm -rv "${ED}${vimfiles}"/{macros,print,tools,tutor} || die
	rm -v "${ED}"/usr/bin/vimtutor || die
		for f in "${ED}${vimfiles}"/colors/*.vim; do
		if [[ ${f} != */@(default).vim ]] ; then
			printf '%s\0' "${f}"
		fi
	done | xargs -0 rm -f || die
		for f in "${ED}${vimfiles}"/syntax/*.vim; do
		if [[ ${f} != */@(conf|crontab|fstab|inittab|resolv|sshdconfig|syntax|nosyntax|synload).vim ]] ; then
			printf '%s\0' "${f}"
		fi
	done | xargs -0 rm -f || die
	fi
	rm -f "${ED}${vimfiles}"/doc/tags || die
	newbashcomp "${FILESDIR}"/xxd-completion xxd
	# Install the gvim icon since both vim/gvim desktop files
	# reference it
	doicon -s scalable "${FILESDIR}"/gvim.svg
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Update icon cache
	xdg_icon_cache_update
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
	# Update icon cache
	xdg_icon_cache_update
}



# vim: filetype=ebuild
