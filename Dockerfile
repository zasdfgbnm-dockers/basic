FROM zasdfgbnm/archlinux-yaourt

# setup
COPY yaourt /
COPY zshrc /etc/zsh/
USER root
RUN /select-mirrors.sh

# install packages
USER user
RUN yaourt -Syu --noconfirm $(grep '^\w.*' /yaourt)
