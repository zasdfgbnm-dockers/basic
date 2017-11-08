FROM zasdfgbnm/archlinux-yaourt

# setup
COPY yaourt /

# install packages
USER user
RUN yaourt -S --noconfirm $(grep '^\w.*' /yaourt)
USER root

# cleanups
RUN yes | pacman -Scc
