# clatd - CLAT, SIIT-DC Edge Relay and IPv6-only for Linux

**clatd** implements the CLAT component of the 464XLAT network architecture
specified in *RFC 6877*. It allows an IPv6-only host to have IPv4 connectivity
that is translated to IPv6 before being routed to an upstream PLAT (which is
typically a Stateful NAT64 operated by the ISP) and there translated back to
IPv4 before being routed to the IPv4 internet. This is especially useful when
local applications on the host requires actual IPv4 connectivity or cannot
make use of DNS64 (for example because they use legacy AF_INET socket calls,
or if they are simply not using DNS64).

**clatd** may also be used to implement an SIIT-DC Edge Relay as described in
*RFC 7756*. In this scenario, the PLAT is in reality a SIIT-DC Border Relay
(see *RFC 7755*) instead of a Stateful NAT64 (see *RFC 6146*). When used as a
SIIT-DC Edge Relay, you will probably want to manually configure the settings
`clat-v4-addr`, `clat-v6-addr`, and `plat-prefix` to mirror the SIIT-DC
Border Relay's configuration.

It relies either on the software package TAYGA by Nathan Lutchansky or on the
kernel module nat46 by Andrew Yourtchenko for the actual translation of packets
between IPv4 and IPv6 (*RFC 6145*) TAYGA may be downloaded from its home page
at <http://www.litech.org/tayga/>, nat46 from its repository at
<https://github.com/ayourtch/nat46>.

## Installing

clatd is available in the following distributions:

- [Arch (AUR)](https://aur.archlinux.org/packages/clatd-git)
- [Debian (sid)](https://packages.debian.org/search?keywords=clatd)
- [Fedora](https://packages.fedoraproject.org/pkgs/clatd/)
- [Nix](https://search.nixos.org/packages?show=clatd&type=packages&query=clatd)
- [OpenSUSE](https://software.opensuse.org/package/clatd)

Probably others also. If clatd is not available from your distribution or
you would like to test the bleeding-edge version of **clatd** from git use
the following commands:

    $ git clone https://github.com/toreanderson/clatd
    $ sudo make -C clatd installdeps start

This will install **clatd**, dependencies, systemd services, NetworkManager
dispatcher integration scripts on your system, enable and start the
clatd.service. Really only recommended for testing.

Beware that TAYGA isn't available in all RPM-based distros (in particular
RHEL and its clones). It is however available in EPEL (see
<https://fedoraproject.org/wiki/EPEL>).


## Using

For extensive usage instruction please refer to the [clatd(8)](./clatd.pod)
manpage.

## Bugs

If you are experiencing any bugs or have any feature requests, head over to
<https://github.com/toreanderson/clatd/issues> and submit a new issue (if
someone else hasn't already done so). Please make sure to include logs with
full debugging output (using `-d -d` on the command line or `debug=2` in
the configuration file) when reporting a bug.

## License

Copyright (c) 2014-2025 Tore Anderson <tore@fud.no>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
