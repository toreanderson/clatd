# clatd Makefile
#
# Copyright (C) 2025 Daniel Gröber <dxld@debian.org>
#
# SPDX-License-Identifier: MIT

DESTDIR=
PREFIX=/usr
SYSCONFDIR=/etc
BINDIR = $(PREFIX)/sbin

SYSTEMCTL = systemctl

CLATD   = $(DESTDIR)$(BINDIR)/clatd
MANPAGE = $(DESTDIR)$(PREFIX)/share/man/man8/clatd.8
SYSTEMD_SYSSERVICEDIR = $(DESTDIR)$(SYSCONFDIR)/systemd/system
NM_DISPATCHER = $(DESTDIR)$(SYSCONFDIR)/NetworkManager/dispatcher.d/50-clatd

all: clatd.8
.ONESHELL:

clatd.8: clatd.pod
	pod2man \
	  --name clatd \
	  --center "clatd - CLAT, SIIT-DC and IPv6-only with many XLAT engines" \
	  --section 8 \
	  $< $@

start: install
	$(SYSTEMCTL) --system daemon-reload
	$(SYSTEMCTL) --system -f --now enable clatd.service

stop:
	$(SYSTEMCTL) --system disable --now clatd.service

uninstall: stop
	-rm $(SYSTEMD_SYSSERVICE)/clatd.service \
	    $(SYSTEMD_SYSSERVICE)/clatd@.service \
	    $(NM_DISPATCHER)

install:
	install -D -m0755 clatd $(CLATD)
	install -D -m0644 clatd.8 $(MANPAGE)
	install -D -m0644 scripts/*.service $(SYSTEMD_SYSSERVICEDIR)/
	install -D -m0755 scripts/clatd.networkmanager $(NM_DISPATCHER)

DEB_PACKAGES = \
 perl-base perl-modules libnet-ip-perl libnet-dns-perl iproute2 nftables tayga

RPM_PACKAGES = \
 perl perl-IPC-Cmd perl-Net-IP perl-Net-DNS perl-File-Temp iproute nftables

installdeps:
	@prog_exists () command -v $$@ >/dev/null 2>&1;
	{ PKGS='$(DEB_PACKAGES)'; PKG=apt; prog_exists $$PKG; } || \
	{ PKGS='$(RPM_PACKAGES)'; PKG=dnf; prog_exists $$PKG; } || \
	{ PKGS='$(RPM_PACKAGES)'; PKG=yum; prog_exists $$PKG; } || \
        { PKG=false; echo 'ERROR: Failed to detect system package manager.'>&2;}
	$(DRY) $$PKG -y $$PKGS
