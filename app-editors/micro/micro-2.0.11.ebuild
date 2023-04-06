# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/blang/semver v3.5.1+incompatible"
	"github.com/blang/semver v3.5.1+incompatible/go.mod"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dustin/go-humanize v1.0.0"
	"github.com/dustin/go-humanize v1.0.0/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/go-errors/errors v1.0.1"
	"github.com/go-errors/errors v1.0.1/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/layeh/gopher-luar v1.0.7"
	"github.com/layeh/gopher-luar v1.0.7/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/mattn/go-isatty v0.0.11"
	"github.com/mattn/go-isatty v0.0.11/go.mod"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/mitchellh/go-homedir v1.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/uniseg v0.1.0"
	"github.com/rivo/uniseg v0.1.0/go.mod"
	"github.com/sergi/go-diff v1.1.0"
	"github.com/sergi/go-diff v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/xo/terminfo v0.0.0-20200218205459-454e5b68f9e8"
	"github.com/xo/terminfo v0.0.0-20200218205459-454e5b68f9e8/go.mod"
	"github.com/yuin/gopher-lua v0.0.0-20190206043414-8bfc7677f583/go.mod"
	"github.com/yuin/gopher-lua v0.0.0-20191220021717-ab39c6098bdb"
	"github.com/yuin/gopher-lua v0.0.0-20191220021717-ab39c6098bdb/go.mod"
	"github.com/zyedidia/clipper v0.0.0-20220613212750-517cd4a6c524"
	"github.com/zyedidia/clipper v0.0.0-20220613212750-517cd4a6c524/go.mod"
	"github.com/zyedidia/clipper v0.1.0"
	"github.com/zyedidia/clipper v0.1.0/go.mod"
	"github.com/zyedidia/glob v0.0.0-20170209203856-dd4023a66dc3"
	"github.com/zyedidia/glob v0.0.0-20170209203856-dd4023a66dc3/go.mod"
	"github.com/zyedidia/go-runewidth v0.0.12"
	"github.com/zyedidia/go-runewidth v0.0.12/go.mod"
	"github.com/zyedidia/go-shellquote v0.0.0-20200613203517-eccd813c0655"
	"github.com/zyedidia/go-shellquote v0.0.0-20200613203517-eccd813c0655/go.mod"
	"github.com/zyedidia/json5 v0.0.0-20200102012142-2da050b1a98d"
	"github.com/zyedidia/json5 v0.0.0-20200102012142-2da050b1a98d/go.mod"
	"github.com/zyedidia/poller v1.0.1"
	"github.com/zyedidia/poller v1.0.1/go.mod"
	"github.com/zyedidia/pty v1.1.15"
	"github.com/zyedidia/pty v1.1.15/go.mod"
	"github.com/zyedidia/pty v1.1.19"
	"github.com/zyedidia/pty v1.1.19/go.mod"
	"github.com/zyedidia/pty v1.1.20"
	"github.com/zyedidia/pty v1.1.20/go.mod"
	"github.com/zyedidia/tcell/v2 v2.0.9"
	"github.com/zyedidia/tcell/v2 v2.0.9/go.mod"
	"github.com/zyedidia/terminal v0.0.0-20180726154117-533c623e2415"
	"github.com/zyedidia/terminal v0.0.0-20180726154117-533c623e2415/go.mod"
	"golang.org/x/sys v0.0.0-20190204203706-41f3e6584952/go.mod"
	"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.4/go.mod"
	"gopkg.in/yaml.v2 v2.2.8"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/zyedidia/micro/tarball/225927b9a25f0d50ea63ea18bc7bb68e404c0cfd -> micro-2.0.11-225927b.tar.gz
https://direct.funtoo.org/ca/6f/8e/ca6f8e4d2af250c2ad8b0294342ce93c2055ca343bdf9cf6d2f9413da6e372b31014dc0abe37135238f47ba3466ae3a7f0ad7592cab972970f3abdc57824a538 -> micro-2.0.11-funtoo-go-bundle-5daf8a0891ba3b2ea8a58c524097c8dbce307168d702c461d1ca03d69a715306bf21e48bf77b55bf1a4d778b31cd3b5f28ce3d1b14f968f41a206c071d6be19f.tar.gz"

DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io https://github.com/zyedidia/micro"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="wayland"

RDEPEND="|| (
	!wayland? (
		x11-misc/xsel
		x11-misc/xclip
	)
	wayland? ( gui-apps/wl-clipboard )
)"

post_src_unpack() {
	mv ${WORKDIR}/zyedidia-* ${S} || die
}

src_compile() {
	go build -mod=mod ./cmd/micro || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}