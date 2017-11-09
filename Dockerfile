FROM zasdfgbnm/archlinux-yaourt

# setup
COPY yaourt zshrc /
USER root
RUN /select-mirrors.sh

# install packages
USER user
RUN yaourt -S --noconfirm $(grep '^\w.*' /yaourt)

# cleanups
USER root
RUN yes | pacman -Scc
