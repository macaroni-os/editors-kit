# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SLOT="0"
IUSE=""
DESCRIPTION="IRC client for Emacs"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
app-xemacs/bbdb
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
