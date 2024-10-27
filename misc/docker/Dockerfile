FROM ubuntu:22.04

RUN apt-get update       && \
    apt-get upgrade -y   && \
    apt-get install -y      \
    qemu                    \
    qemu-kvm                \
    nasm                    \
    gcc-multilib            \
    binutils                \
    libvirt-daemon-system   \
    libvirt-clients         \
    bridge-utils            \
    virt-manager            \
    x11-apps                \
    build-essential         \
    libgmp3-dev             \
    libmpfr-dev             \
    libmpc-dev              \
    gcc                     \
    curl                    \
    make                    \
    bzip2

# Set up environment variables for cross-compiler
ENV PREFIX="/usr/local/i386elfgcc"
ENV TARGET="i386-elf"
ENV PATH="$PREFIX/bin:$PATH"

# Download, build, and install binutils
RUN mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz && \
    tar xvf binutils-2.24.tar.gz && \
    mkdir binutils-build && \
    cd binutils-build && \
    ../binutils-2.24/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX && \
    make && make install

# Download, build, and install GCC for cross-compilation
RUN cd /tmp/src && \
    curl -O https://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2 && \
    tar xvf gcc-4.9.1.tar.bz2 && \
    mkdir gcc-build && \
    cd gcc-build && \
    CFLAGS="-fPIC -w" CXXFLAGS="-fPIC -w -std=gnu++98" ../gcc-4.9.1/configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-libssp --enable-languages=c --without-headers && \
    make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc

# Verify the cross-compiler installation
RUN $TARGET-gcc --version

# Set up working directory and environment for running GUI applications
VOLUME /root/env
WORKDIR /root/env
ENV DISPLAY=:0

# Command to keep the container running if needed
CMD ["bash"]

# Optional: add a default entry point to start QEMU
# ENTRYPOINT ["qemu-system-x86_64"]