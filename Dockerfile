FROM zasdfgbnm/archlinux-yaourt

# setup
USER root
COPY yaourt pacman /
COPY zshrc /etc/zsh/
COPY locale.gen /etc/locale.gen

# RUN /select-mirrors.sh
RUN sed -i 's/NoExtract/#NoExtract/g' /etc/pacman.conf
RUN sed -i 's/HoldPkg/#HoldPkg/g' /etc/pacman.conf

RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman -S --noconfirm pacman pacman-contrib
RUN pacman -S --noconfirm man-db man-pages
RUN pacman -Qqn | pacman -S --noconfirm  -
RUN pacman -S --noconfirm base base-devel linux
RUN locale-gen
RUN pacman -S --noconfirm $(grep '^\w.*' /pacman)

# install packages
USER user

RUN yaourt -S --noconfirm mkinitcpio-docker-hooks
RUN sudo sed -i 's/archlinux\/base/zasdfgbnmsystem\/basic/g' /etc/docker-btrfs.json
RUN sudo perl -i -p -e 's/(?<=^HOOKS=\()(.*)(?=\))/$1 docker-btrfs/g' /etc/mkinitcpio.conf

RUN yaourt -Syua --noconfirm || true
RUN for i in $(grep '^\w.*' /yaourt); do yaourt -S --noconfirm $i || true; done

# setting up services
RUN sudo systemctl enable sshd
RUN sudo sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# copy gen_boot
COPY gen_boot /usr/bin
