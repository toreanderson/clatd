install:
	# Install the main script to /usr/sbin
	install -m0755 clatd /usr/sbin/clatd
	# Install manual page if pod2man is installed
	pod2man --name clatd --center "clatd - a CLAT implementation for Linux" --section 8 README.pod /usr/share/man/man8/clatd.8 && gzip -f9 /usr/share/man/man8/clatd.8 || echo "pod2man is required to generate manual page"
	# Install systemd service file if applicable for this system
	if test -x /usr/bin/systemctl && test -d "/etc/systemd/system"; then install -m0644 scripts/clatd.systemd /etc/systemd/system/clatd.service && systemctl daemon-reload; fi
	if test -e "/etc/systemd/system/clatd.service" && test ! -e "/etc/systemd/system/multi-user.target.wants/clatd.service"; then systemctl enable clatd.service; fi
	# Install upstart service file if applicable for this system
	if test -x /sbin/initctl && test -d "/etc/init"; then install -m0644 scripts/clatd.upstart /etc/init/clatd.conf; fi
	# Install NetworkManager dispatcher script if applicable
	if test -d /etc/NetworkManager/dispatcher.d; then install -m0755 scripts/clatd.networkmanager /etc/NetworkManager/dispatcher.d/50-clatd; fi

installdeps:
	# .deb/apt-get based distros
	if test -x /usr/bin/apt-get; then apt-get -y install perl-base perl-modules libnet-ip-perl libnet-dns-perl libio-socket-inet6-perl iproute iptables tayga; fi
	# .rpm/YUM-based distros
	if test -x /usr/bin/yum; then yum -y install perl perl-Net-IP perl-Net-DNS perl-IO-Socket-INET6 perl-File-Temp iproute iptables; fi
	# to get TAYGA on .rpm/YUM-based distros, we unfortunately need to install from source
	if test -x /usr/bin/yum && test ! -x /usr/sbin/tayga; then echo "TAYGA isn't packaged for YUM-based distros, will download and compile the source in 5 seconds (^C interrupts)" && sleep 5 && yum -y install gcc tar wget bzip2 && wget http://www.litech.org/tayga/tayga-0.9.2.tar.bz2 && bzcat tayga-0.9.2.tar.bz2 | tar x && cd tayga-0.9.2 && ./configure --prefix=/usr && make && make install && rm -rf ../tayga-0.9.2.tar.bz2 ../tayga-0.9.2; fi
