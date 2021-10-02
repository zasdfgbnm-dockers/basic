FROM zasdfgbnm/archlinux-yay

# setup
USER root

# setup pacman to get a full image
RUN sed -i 's/NoExtract/#NoExtract/g' /etc/pacman.conf
RUN sed -i 's/HoldPkg/#HoldPkg/g' /etc/pacman.conf

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
COPY basic /usr/local/share/packages/basic
COPY basic /tmp/basic
USER user
RUN sudo chown -R user:user /tmp/basic
WORKDIR /tmp/basic
RUN makepkg -p ./PKGBUILD --printsrcinfo | awk '{$1=$1};1' | grep -oP '(?<=^depends = ).*' | xargs yay -S --noconfirm
RUN makepkg -i --noconfirm

RUN sudo pip install xonsh-tcg

