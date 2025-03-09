FROM kalilinux/kali-rolling:latest

ARG KALI_METAPACKAGE=core
ARG KALI_DESKTOP=xfce
ARG BASE_PACKAGES="vim less iputils-ping net-tools"  # Core set of tools
ENV DEBIAN_FRONTEND noninteractive
ENV USER root
ENV VNCEXPOSE 1
ENV VNCWEB 0
ENV VNCPORT 5900
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16
ENV NOVNCPORT 8080

# Base packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
    kali-linux-${KALI_METAPACKAGE} \
    kali-tools-top10 \
    kali-desktop-${KALI_DESKTOP} \
    tightvncserver xfonts-base \
    dbus dbus-x11 \
    novnc \
    ${BASE_PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Common tools
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    burpsuite \
    wordlists && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Extra packages for specific challenges
ARG EXTRA_PACKAGES=""
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    ${EXTRA_PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
