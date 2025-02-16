FROM ubuntu:14.04

# ENV
ENV DEBIAN_FRONTEND noninteractive
ENV USER Dopaemon
ENV HOSTNAME KernelPanic-OpenSource
ENV USE_CCACHE 1
ENV LC_ALL C
ENV CCACHE_COMPRESS 1
ENV CCACHE_SIZE 50G
ENV CCACHE_DIR /tmp/ccache
ENV CCACHE_EXEC /usr/bin/ccache 
ENV USE_CCACHE true

# Install dependencies
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install bison libssl-dev build-essential curl flex git gnupg gperf liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev build-essential kernel-package libncurses5-dev bzip2 git python sudo gcc g++ openssh-server tar gzip ca-certificates -y

RUN apt-get purge openjdk-* -y

RUN apt-get install openjdk-6-jdk openjdk-6-jre -y

RUN set -x \
    && apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq \
        autoconf automake axel bc bison build-essential ccache clang cmake curl expat flex g++ g++-multilib gawk gcc gcc-multilib git git-core gnupg gperf htop imagemagick kmod lib32ncurses5-dev lib32readline-dev lib32z1-dev libc6-dev libcap-dev libexpat1-dev libgmp-dev liblz4-* liblz4-tool liblzma* libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libssl-dev libtinfo5 libtool libwxgtk3.0-dev libxml-simple-perl libxml2 libxml2-utils lzip lzma* lzop maven ncftp ncurses-dev patch pkg-config pngcrush pngquant python python-all-dev re2c rsync schedtool squashfs-tools subversion sudo texinfo unzip w3m xsltproc zip zlib1g-dev zram-config && \
    apt-get clean

# Install repo
RUN set -x \
    && curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/local/bin/repo

RUN rm -rf /var/lib/apt/lists/*

# Link Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# Add User
# Why? Well for avoid something wrong
# I've seen some notes for not using root when build
RUN useradd -ms /bin/bash doraemon
RUN echo "doraemon ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER doraemon
WORKDIR /home/doraemon

# Git
RUN git config --global user.email "polarisdp@gmail.com"
RUN git config --global user.name "dopaemon"
RUN git config --global color.ui true

# Work in the build directory, repo is expected to be init'd here
WORKDIR /src

# This is where the magic happens~
ENTRYPOINT ["/bin/bash"]
