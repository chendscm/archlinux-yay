FROM archlinux:base

# https://github.com/actions/virtual-environments/issues/2658
# https://github.com/lxqt/lxqt-panel/pull/1562
# Work-around the issue with glibc 2.33 on old Docker engines
# Extract files directly as pacman is also affected by the issue
ENV patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst
RUN curl -LO https://repo.archlinuxcn.org/x86_64/$patched_glibc
RUN bsdtar -C / -xvf $patched_glibc

RUN pacman-key --init
RUN ls /usr/lib/sysusers.d/*.conf | /usr/share/libalpm/scripts/systemd-hook sysusers

COPY remove-pkg-cache.hook /etc/pacman.d/hooks/

COPY custom_repo.conf /
RUN cat /custom_repo.conf >> /etc/pacman.conf

RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm sudo yay

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -m user; usermod -a -G wheel user

USER user
