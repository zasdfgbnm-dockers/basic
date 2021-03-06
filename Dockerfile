FROM zasdfgbnm/archlinux-yaourt

# setup
USER root
COPY pacman.conf /opt/zasdfgbnmsystem/basic/pacman.conf

# setup pacman to get a full image
RUN sed -i 's/NoExtract/#NoExtract/g' /etc/pacman.conf
RUN sed -i 's/HoldPkg/#HoldPkg/g' /etc/pacman.conf
RUN cat /opt/zasdfgbnmsystem/basic/pacman.conf >> /etc/pacman.conf

# setup keyring
RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

# reinstall packages to restore all its files
RUN pacman -Sy --noconfirm pacman pacman-contrib
RUN pacman -Sy --noconfirm man-db man-pages
RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm base base-devel linux linux-firmware

RUN pacman -Qqn | pacman -S --noconfirm  -

# install packages
USER user
RUN yaourt -Sy --noconfirm zasdfgbnmsystem-basic

