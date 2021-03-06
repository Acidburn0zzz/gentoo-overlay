# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="A free, open source, web-based media server in Java."
HOMEPAGE="http://www.subsonic.org"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${PN}-${PV}-standalone.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="virtual/jre
		media-sound/lame
		virtual/ffmpeg"

INSTALL_BASE="/opt/${PN}"

S="${WORKDIR}"
SUBSONIC_HOME="/var/${PN}"
USER_GROUP="subsonic"

pkg_setup() {
	ebegin "Creating ${UG} user and group"
    enewgroup "${USER_GROUP}"
    enewuser "${USER_GROUP}" -1 -1 ${SUBSONIC_HOME} "${USER_GROUP}"
}

src_install() {
	dodoc README.TXT
	dohtml "Getting Started.html"
	
	insinto ${INSTALL_BASE}
	doins subsonic-booter-jar-with-dependencies.jar
	doins subsonic.war
	
	exeinto ${INSTALL_BASE}
	doexe subsonic.sh
	
	dodir ${SUBSONIC_HOME}
	fowners ${USER_GROUP}:${USER_GROUP} ${SUBSONIC_HOME}
	
	newinitd "${FILESDIR}/subsonic.initd" subsonic
	newconfd "${FILESDIR}/subsonic.confd" subsonic

	dosym ${INSTALL_BASE}/subsonic.sh /opt/bin/subsonic	
}
