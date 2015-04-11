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

echo -e "Please enter root password"
sudo -i

echo -e "Installing Packages Requirements."
apt-get -y build-dep xen

apt-get -y install build-essential

apt-get -y install bridge-utils libncurses-dev python-dev uuid uuid-dev libglib2.0-dev libyajl-dev bcc gcc-multilib iasl libpci-dev mercurial flex bison libaio-dev build-essential gettext libpixman-1-dev bin86 gawk bridge-utils iproute libcurl3 libcurl4-openssl-dev bzip2 module-init-tools transfig tgif texinfo texlive-latex-base texlive-latex-recommended texlive-fonts-extra texlive-fonts-recommended pciutils-dev mercurial make gcc libc6-dev zlib1g-dev python python-dev python-twisted libncurses5-dev patch libvncserver-dev libsdl-dev libbz2-dev e2fslibs-dev git-core uuid-dev ocaml ocaml-findlib libx11-dev bison flex xz-utils libyajl-dev

#..............Download Xen source..............

echo -e "Downloading source code of Xen from repository."
cd ~/
wget http://bits.xensource.com/oss-xen/release/4.3.0/xen-4.3.0.tar.gz
tar xvf xen-4.3.0.tar.gz

#..............Patching source code..............

echo -e "Patching source code."
sed '108 c err = xenbus_printf(xbt, nodename, "page-ref","%lu", virt_to_mfn(s));' xen-4.3.0/extras/mini-os/fbfront.c > temp
sed '466 c err = xenbus_printf(xbt, nodename, "page-ref","%lu", virt_to_mfn(s));' temp > xen-4.3.0/extras/mini-os/fbfront.c
sed '416 c if (sscanf(s, "%x:%x:%x.%lx", dom, bus, slot, fun) != 4) {' xen-4.3.0/extras/mini-os/pcifront.c > temp
cat temp > xen-4.3.0/extras/mini-os/pcifront.c
sed '675 c sscanf((char *)(rep + 1), "%lu", xbt);' xen-4.3.0/extras/mini-os/xenbus/xenbus.c > temp
sed '772 c sscanf(dom_id, "%u", (unsigned int*)&ret);' temp > xen-4.3.0/extras/mini-os/xenbus/xenbus.c
rm -fr temp

#..............Installing Xen..............

echo -e "Compiling Xen 4.3.0 from source and installation of Xen."
cd xen-4.3.0
./configure --enable-githttp
make world
make install
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
