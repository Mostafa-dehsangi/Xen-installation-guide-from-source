# ***
# Author:    Mostafa Dehsangi
# Created:   April 10 2015
# Email:     dehsangi.mostafa@gmail.com
# ***
#
#	Installing Xen Hypervisor on Ubuntu 14.04 (64-bit)
#
#
# README:
#
#	Root access is required. Before trying to install
#	Xen, make sure that you can access the Internet 
#	on your computer

#..............Install packages dependencies..............

echo -e "Installing Packages Requirements."

sudo apt-get -y install build-essential libncurses-dev python-dev uuid uuid-dev libglib2.0-dev libyajl-dev bcc gcc-multilib iasl libpci-dev mercurial flex bison libaio-dev

sudo apt-get -y install patch libncurses5-dev python bin86 bzip2 module-init-tools make gcc libc6-dev libcurl3 iproute

sudo apt-get -y install gettext libpixman-1-dev

sudo apt-get -y install gawk libcurl4-openssl-dev transfig tgif

sudo apt-get -y install texinfo texlive-latex-base texlive-latex-recommended texlive-fonts-extra texlive-fonts-recommended pciutils-dev

sudo apt-get -y install zlib1g-dev python-twisted libvncserver-dev libsdl-dev

sudo apt-get -y install libbz2-dev e2fslibs-dev git-core ocaml ocaml-findlib libx11-dev xz-utils

apt-get build-dep xen

#..............Download Xen source..............

echo -e "Downloading source code of Xen from repository."
`cd ~/;wget http://bits.xensource.com/oss-xen/release/4.3.0/xen-4.3.0.tar.gz;tar xvf xen-4.3.0.tar.gz`

#..............Patching source code..............

echo -e "Patching source code."
sed '108 c err = xenbus_printf(xbt, nodename, "page-ref","%lu", virt_to_mfn(s));' ~/xen-4.3.0/extras/mini-os/fbfront.c > temp
sed '466 c err = xenbus_printf(xbt, nodename, "page-ref","%lu", virt_to_mfn(s));' temp > ~/xen-4.3.0/extras/mini-os/fbfront.c
sed '416 c if (sscanf(s, "%x:%x:%x.%lx", dom, bus, slot, fun) != 4) {' ~/xen-4.3.0/extras/mini-os/pcifront.c > temp
cat temp > ~/xen-4.3.0/extras/mini-os/pcifront.c
sed '675 c sscanf((char *)(rep + 1), "%lu", xbt);' ~/xen-4.3.0/extras/mini-os/xenbus/xenbus.c > temp
sed '772 c sscanf(dom_id, "%u", (unsigned int*)&ret);' temp > ~/xen-4.3.0/extras/mini-os/xenbus/xenbus.c
rm -fr temp

#..............Installing Xen..............

echo -e "Compiling Xen 4.3.0 from source and installation of Xen."
`cd ~/xen-4.3.0;./configure --enable-githttp;make world;make install`
/sbin/ldconfig
update-rc.d xencommons defaults 19 18
update-rc.d xend defaults 20 21
update-rc.d xendomains defaults 21 20
update-rc.d xen-watchdog defaults 22 23
/etc/init.d/xencommons start
/etc/init.d/xendomains start
/etc/init.d/xen-watchdog start
update-grub

#..........................................
echo -e "Xen Hypervisor 4.3.0 has been installed."
