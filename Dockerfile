FROM ubuntu:18.04 AS ffmpeg_deps_install

RUN apt-get update && apt-get install --no-install-recommends -y\
        git \
        ca-certificates\
        wget \
        less \
        nano \
        nasm \
        yasm \
        cmake \
        automake \
        pkg-config \
        build-essential \
        libass-dev \
        libfreetype6-dev \
        libtool \
        libvorbis-dev \
        zlib1g-dev \
        libx264-dev \
        libx265-dev libnuma-dev \
        libvpx-dev \
        libfdk-aac-dev \
        libmp3lame-dev \
        libopus-dev
        
        
FROM ffmpeg_deps_install as ffmpeg_clone

ARG FFMPEG_GIT_URL=https://git.ffmpeg.org/ffmpeg.git
ARG GIT_USERNAME
ARG GIT_PASSWORD
COPY git-credentials.sh /root/git-credentials.sh
RUN git config --global credential.helper "/bin/bash /root/git-credentials.sh"
RUN  git clone "$FFMPEG_GIT_URL" ~/ffmpeg_sources && cd ~/ffmpeg_sources && git fetch --tags

FROM ffmpeg_clone as ffmpeg_builder
ARG FFMPEG_VERSION

RUN [ -z "$FFMPEG_VERSION" ] && exit 0 || echo "Using ffmpeg version ${FFMPEG_VERSION}" && cd ~/ffmpeg_sources && git checkout "$FFMPEG_VERSION"
RUN cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir aom_build && \
cd aom_build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
PATH="$HOME/bin:$PATH" make && \
make install