FROM archlinux:base
USER root
RUN ls /usr/lib/sysusers.d/*.conf | /usr/share/libalpm/scripts/systemd-hook sysusers

COPY remove-pkg-cache.hook /etc/pacman.d/hooks/

COPY resolv.conf /etc

COPY custom_repo.conf /
RUN cat custom_repo.conf >> /etc/pacman.conf

RUN pacman -Sy --noconfirm pacman-contrib
RUN cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
RUN sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
RUN rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
RUN pacman -Syyu --noconfirm

RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm sudo yay

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -m user; usermod -a -G wheel user

USER user
