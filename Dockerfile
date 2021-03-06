FROM ubuntu:20.04

# http://ffmpeg.org/download.html
# http://www.iiwnz.com/compile-ffmpeg-with-rtmps-for-facebook/
RUN apt-get update
# https://serverfault.com/a/992421
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install \
            ffmpeg \
            build-essential \
            autoconf \
            automake \
            cmake \
            libtool \
            checkinstall \
            nasm \
            yasm \
            libass-dev \
            libfreetype6-dev \
            libsdl2-dev \
            libtool \
            libva-dev \
            libvdpau-dev \
            libvorbis-dev \
            libxcb1-dev \
            libxcb-shm0-dev \
            libxcb-xfixes0-dev \
            pkg-config \
            texinfo \
            wget \
            zlib1g-dev \
            libchromaprint-dev \
            frei0r-plugins-dev \
            ladspa-sdk \
            libcaca-dev \
            libcdio-paranoia-dev \
            libcodec2-dev \
            libfontconfig1-dev \
            libfreetype6-dev \
            libfribidi-dev \
            libgme-dev \
            libgsm1-dev \
            libjack-dev \
            libmodplug-dev \
            libmp3lame-dev \
            libopencore-amrnb-dev \
            libopencore-amrwb-dev \
            libopenjp2-7-dev \
            libopenmpt-dev \
            libopus-dev \
            libpulse-dev \
            librsvg2-dev \
            librubberband-dev \
            librtmp-dev \
            libshine-dev \
            libsmbclient-dev \
            libsnappy-dev \
            libsoxr-dev \
            libspeex-dev \
            libssh-dev \
            libtesseract-dev \
            libtheora-dev \
            libtwolame-dev \
            libv4l-dev \
            libvo-amrwbenc-dev \
            libvpx-dev \
            libwavpack-dev \
            libwebp-dev \
            libx264-dev \
            libx265-dev \
            libxvidcore-dev \
            libxml2-dev \
            libzmq3-dev \
            libzvbi-dev \
            liblilv-dev \
            libmysofa-dev \
            libopenal-dev \
            opencl-dev \
            gnutls-dev \
            libfdk-aac-dev

RUN wget https://github.com/FFmpeg/FFmpeg/archive/n4.1.3.tar.gz && \
    tar -xvf n4.1.3.tar.gz

RUN cd FFmpeg-n4.1.3 && \
  ./configure \
        --disable-shared \
        --enable-static \
        --enable-pthreads \
        --enable-gpl \
        --enable-nonfree \
        --enable-libass \
        --enable-libfdk-aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-filters \
        --enable-openssl \
        --enable-runtime-cpudetect \
        --extra-version=patrickz && \
        make && make install

WORKDIR /usr/app
ENV URL_RTMPS=""
CMD ffmpeg \
    -re \
    -i input.mp4 \
    -pix_fmt yuv420p \
    -c:v libx264 \
    -b:v 1000k \
    -g 30 -keyint_min 120 \
    -profile:v baseline \
    -preset veryfast \
    -c:a aac -b:a 96k  \
    -f flv \
    $URL_RTMPS