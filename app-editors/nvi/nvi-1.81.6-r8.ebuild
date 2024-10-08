# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db-use flag-o-matic

DESCRIPTION="Vi clone"
HOMEPAGE="https://sites.google.com/a/bostic.com/keithbostic/vi"
SRC_URI="https://mirror.csclub.uwaterloo.ca/MacPorts/mpdistfiles/nvi/nvi-1.81.6.tar.bz2 -> nvi-1.81.6.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="perl tcl unicode"

CDEPEND=">=sys-libs/db-4.2.52_p5:=
	>=sys-libs/ncurses-5.6-r2:=
	perl? ( dev-lang/perl )
	tcl? ( >=dev-lang/tcl-8.5:0= )"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	app-eselect/eselect-vi"

REQUIRED_USE="tcl? ( !unicode )"

PATCHES=(
	"${FILESDIR}"/${P}-strlen-macro-renaming.patch
	"${FILESDIR}"/${P}-db44.patch
	"${FILESDIR}"/${P}-db.patch
	"${FILESDIR}"/${P}-perl-as-needed.patch
	"${FILESDIR}"/${P}-perl-shortnames.patch
	"${FILESDIR}"/${P}-ac_config_header.patch
	"${FILESDIR}"/${P}-use_pkgconfig_for_ncurses.patch
	"${FILESDIR}"/${P}-printf-types.patch
	"${FILESDIR}"/${P}-ac_config_sys5_pty.patch
	)

src_prepare() {
	default

	cd dist || die
	chmod +x findconfig || die

	mv configure.{in,ac} || die
	sed -i -e "s@-ldb@-l$(db_libname)@" configure.ac || die
	sed -i -e "s@^install-\(.*\)-local:@install-\1-hook:@" Makefile.am || die
	eautoreconf -Im4
}

src_configure() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use unicode && myconf="${myconf} --enable-widechar"
	use tcl && myconf="${myconf} --enable-tclinterp"

	append-cppflags "-D_PATH_MSGCAT=\"\\\"${EPREFIX%/}/usr/share/vi/catalog/\\\"\""
	append-cppflags -I"$(db_includedir)"

	# Darwin doesn't have stropts.h, bug #619416
	[[ ${CHOST} == *-darwin* ]] && export vi_cv_sys5_pty=no

	pushd dist 2>/dev/null || die
	econf \
		--program-prefix=n \
		${myconf}
	popd 2>/dev/null || die
}

src_compile() {
	emake -C dist
}

src_install() {
	emake -C dist DESTDIR="${D}" install
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update --if-unset
}