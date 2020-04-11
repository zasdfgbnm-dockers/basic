FROM zasdfgbnm/archlinux-yaourt

# setup
USER root
COPY pacman /
COPY locale.gen /etc/locale.gen
COPY kernel.conf /etc/sysctl.d/kernel.conf

# setup pacman to get a full image
RUN sed -i 's/NoExtract/#NoExtract/g' /etc/pacman.conf
RUN sed -i 's/HoldPkg/#HoldPkg/g' /etc/pacman.conf

# setup keyring
RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

# reinstall packages to restore all its files
RUN pacman -S --noconfirm pacman pacman-contrib
RUN pacman -S --noconfirm man-db man-pages
RUN pacman -Qqn | pacman -S --noconfirm  -
RUN pacman -S --noconfirm base base-devel linux linux-firmware

# install packages
RUN pacman -S --noconfirm $(grep '^\w.*' /pacman)
USER user
RUN yaourt -S --noconfirm fkill nerd-fonts-complete

# make initramfs bootable
RUN yaourt -S --noconfirm mkinitcpio-docker-hooks
RUN sudo sed -i 's/archlinux\/base/zasdfgbnmsystem\/basic/g' /etc/docker-btrfs.json
RUN sudo perl -i -p -e 's/(?<=^HOOKS=\()(.*)(?=\))/$1 docker-btrfs/g' /etc/mkinitcpio.conf

# setting up services
RUN sudo systemctl enable sshd docker netdata NetworkManager NetworkManager-dispatcher iptables
RUN sudo sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sudo sed -i 's/#NAutoVTs/NAutoVTs/g' /etc/systemd/logind.conf

# copy scripts
COPY gen_boot /usr/bin/
COPY dockersh /usr/bin/
