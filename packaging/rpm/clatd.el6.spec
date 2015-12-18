Summary: Implements IPv4 access in an IPv6-only environment.
Name: clatd
Version: 1.4
Release: 1
Source0: %{name}-%{version}.tar.gz
License: Copyright (c) 2014 Tore Anderson <tore@fud.no>
Group: Utilities/System
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}
BuildArch: noarch
Packager: David Summers <david@summersoft.fay.ar.us>
Url: https://github.com/toreanderson/clatd
Requires: perl
Requires: perl-IO-Socket-INET6
Requires: perl-Net-DNS
Requires: perl-Net-IP
Requires: tayga

%description
Implements IPv4 access in an IPv6-only environment as the CLAT component of
the 464XLAT network architecture specified in RFC 6877. 

It connects to an upstream PLAT (which is a typically a Stateful NAT64).

%changelog
* Thu Dec 17 2015 David Summers <david@summersoft.fay-ar.us> 1.4-1
- Updated to 1.4.

* Wed Apr 08 2015 David Summers <david@summersoft.fay.ar.us> 1.0-1
- First packaged version

%prep
%setup -q -n %{name}-%{version}

%build

%install
rm -rf $RPM_BUILD_ROOT

# Copy clatd perl script.
mkdir -p $RPM_BUILD_ROOT/usr/sbin/
cp clatd $RPM_BUILD_ROOT/usr/sbin

# Copy init script for upstart.
mkdir -p $RPM_BUILD_ROOT/etc/init
cp scripts/clatd.upstart $RPM_BUILD_ROOT/etc/init/clatd.conf

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%doc README.pod LICENCE
/etc/init/*
/usr/sbin/*
