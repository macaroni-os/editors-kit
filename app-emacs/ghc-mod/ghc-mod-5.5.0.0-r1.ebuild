# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ebuild generated by hackport 0.4.6

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"
inherit elisp-common haskell-cabal

DESCRIPTION="Happy Haskell Programming"
HOMEPAGE="http://www.mew.org/~kazu/proj/ghc-mod/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

RESTRICT=test # doctests break on modules collisions: temporary / temporary-rc

RDEPEND=">=dev-haskell/binary-0.5.1.0:=[profile?] <dev-haskell/binary-0.8:=[profile?]
	>=dev-haskell/cabal-helper-0.6.3.0:=[profile?] <dev-haskell/cabal-helper-0.7:=[profile?]
	dev-haskell/convertible:=[profile?]
	>=dev-haskell/djinn-ghc-0.0.2.2:=[profile?] <dev-haskell/djinn-ghc-0.1:=[profile?]
	>=dev-haskell/extra-1.4:2=[profile?] <dev-haskell/extra-1.5:2=[profile?]
	>=dev-haskell/fclabels-2.0:=[profile?] <dev-haskell/fclabels-2.1:=[profile?]
	<dev-haskell/ghc-paths-0.2:=[profile?]
	<dev-haskell/ghc-syb-utils-0.3:=[profile?]
	<dev-haskell/haskell-src-exts-1.18:=[profile?]
	>=dev-haskell/hlint-1.8.61:=[profile?] <dev-haskell/hlint-1.10:=[profile?]
	>=dev-haskell/monad-control-1.0:=[profile?] <dev-haskell/monad-control-1.1:=[profile?]
	>=dev-haskell/monad-journal-0.4:=[profile?] <dev-haskell/monad-journal-0.8:=[profile?]
	>=dev-haskell/mtl-2.0:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	<dev-haskell/old-time-1.2:=[profile?]
	>=dev-haskell/optparse-applicative-0.11.0:=[profile?] <dev-haskell/optparse-applicative-0.13.0:=[profile?]
	>=dev-haskell/pipes-4.1:=[profile?] <dev-haskell/pipes-4.2:=[profile?]
	>=dev-haskell/safe-0.3.9:=[profile?] <dev-haskell/safe-0.4:=[profile?]
	<dev-haskell/split-0.3:=[profile?]
	<dev-haskell/syb-0.7:=[profile?]
	<dev-haskell/temporary-1.3:=[profile?]
	<dev-haskell/text-1.3:=[profile?]
	<dev-haskell/transformers-0.5:=[profile?]
	<dev-haskell/transformers-base-0.5:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.14
	test? ( >=dev-haskell/doctest-0.9.3
		dev-haskell/executable-path
		>=dev-haskell/hspec-2.0.0 )
"
SITEFILE=50${PN}-gentoo.el

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.5.0.0-gentoo.patch
}

src_compile() {
	haskell-cabal_src_compile
	if use emacs ; then
		pushd elisp
		elisp-compile *.el || die
		popd
	fi
}

src_install() {
	haskell-cabal_src_install
	if use emacs ; then
		pushd "${S}"
		elisp-install ghc-mod elisp/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
		popd
	fi
}

pkg_postinst() {
	haskell-cabal_pkg_postinst
	if use emacs ; then
		elisp-site-regen
		elog "To configure ghc-mod either add this line to ~/.emacs:"
		elog "(autoload 'ghc-init \"ghc\" nil t)"
		elog "and either this line:"
		elog "(add-hook 'haskell-mode-hook (lambda () (ghc-init)))"
		elog "or if you wish to use flymake:"
		elog "(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))"
	fi
}

pkg_postrm() {
	haskell-cabal_pkg_postrm
	if use emacs ; then
		elisp-site-regen
	fi
}
