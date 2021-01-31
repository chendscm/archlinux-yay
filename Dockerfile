FROM archlinux:base-devel
USER root
RUN ls /usr/lib/sysusers.d/*.conf | /usr/share/libalpm/scripts/systemd-hook sysusers

COPY remove-pkg-cache.hook /etc/pacman.d/hooks/

COPY custom_repo.conf /
RUN cat custom_repo.conf >> /etc/pacman.conf

RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm sudo yay

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -m chend; usermod -a -G wheel chend

USER chend
