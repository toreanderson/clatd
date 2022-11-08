DESTDIR=
PREFIX=/usr
SYSCONFDIR=/etc

APT_GET:=$(shell which apt-get)
DNF_OR_YUM:=$(shell which dnf || which yum)
INITCTL:=$(shell which initctl)
SYSTEMCTL:=$(shell which systemctl)
TAYGA:=$(shell which tayga)

install:
	# Install the main script
	install -m0755 clatd $(DESTDIR)$(PREFIX)/sbin/clatd
	# Install manual page if pod2man is installed
	pod2man --name clatd --center "clatd - a CLAT implementation for Linux" --section 8 README.pod $(DESTDIR)$(PREFIX)/share/man/man8/clatd.8 && gzip -f9 $(DESTDIR)$(PREFIX)/share/man/man8/clatd.8 || echo "pod2man is required to generate manual page"
	# Install systemd service file if applicable for this system
	if test -x "$(SYSTEMCTL)" && test -d "$(DESTDIR)$(SYSCONFDIR)/systemd/system"; then install -m0644 scripts/clatd.systemd $(DESTDIR)$(SYSCONFDIR)/systemd/system/clatd.service && $(SYSTEMCTL) daemon-reload; fi
	if test -e "$(DESTDIR)$(SYSCONFDIR)/systemd/system/clatd.service" && test ! -e "$(DESTDIR)$(SYSCONFDIR)/systemd/system/multi-user.target.wants/clatd.service"; then $(SYSTEMCTL) enable clatd.service; fi
	# Install upstart service file if applicable for this system
	if test -x "$(INITCTL)" && test -d "$(DESTDIR)$(SYSCONFDIR)/init"; then install -m0644 scripts/clatd.upstart $(DESTDIR)$(SYSCONFDIR)/init/clatd.conf; fi
	# Install NetworkManager dispatcher script if applicable
	if test -d $(DESTDIR)$(SYSCONFDIR)/NetworkManager/dispatcher.d; then install -m0755 scripts/clatd.networkmanager $(DESTDIR)$(SYSCONFDIR)/NetworkManager/dispatcher.d/50-clatd; fi

installdeps:
	# .deb/apt-get based distros
	if test -x "$(APT_GET)"; then $(APT_GET) -y install perl-base perl-modules libnet-ip-perl libnet-dns-perl libio-socket-ip-perl iproute2 iptables tayga; fi
	# .rpm/DNF/YUM-based distros
	if test -x "$(DNF_OR_YUM)"; then $(DNF_OR_YUM) -y install perl perl-Net-IP perl-Net-DNS perl-IO-Socket-IP perl-File-Temp iproute iptables; fi
	# If necessary, try to install the TAYGA .rpm using dnf/yum. It is unfortunately not available in all .rpm based distros (in particular CentOS/RHEL).
	if test -x "$(DNF_OR_YUM)" && test ! -x "$(TAYGA)"; then $(DNF_OR_YUM) -y install tayga || echo "ERROR: Failed to install TAYGA using dnf/yum, the package is probably not included in your distro. Try enabling the EPEL repo <URL: https://fedoraproject.org/wiki/EPEL> and try again, or install TAYGA <URL: http://www.litech.org/tayga> directly from source."; exit 1; fi
