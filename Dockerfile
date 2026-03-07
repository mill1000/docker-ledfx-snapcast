
# Base image for build
FROM alpine:latest AS build
RUN apk add --update build-base pkgconfig autoconf automake libtool cmake alsa-lib-dev

# Snapcast build
FROM build AS snapcast-build
RUN apk add --update soxr-dev avahi-dev boost-dev libvorbis-dev opus-dev flac-dev expat-dev openssl-dev pipewire-dev
WORKDIR /snapcast
COPY snapcast .
RUN mkdir build && cd build && cmake .. -DBUILD_SERVER=OFF -DBUILD_CLIENT=ON -DBUILD_WITH_PIPEWIRE=ON
RUN cd build && cmake --build . && cmake --install . --prefix /snapcast-install

# Ledfx build
FROM build AS ledfx-build
RUN apk add --update python3 py3-pip python3-dev git aubio-dev libsamplerate-dev linux-headers
RUN python3 -m venv /app/.venv && source /app/.venv/bin/activate && CFLAGS="-Wno-incompatible-pointer-types" pip install --verbose ledfx

# Run image
FROM alpine:latest

# Copy built packages
COPY --from=snapcast-build /snapcast-install /
COPY --from=ledfx-build /app /app

# Install runtime dependencies
RUN apk add --update xz soxr libvorbis opus flac alsa-lib libgcc libstdc++ expat avahi-libs alsa-utils python3 aubio pipewire pipewire-alsa wireplumber pipewire-tools portaudio s6-overlay

# Setup s6-overlay
COPY s6-rc.d /etc/s6-overlay/s6-rc.d

# Copy pipewire/wireplumber configs
COPY 10-pw-snapcast.conf /etc/pipewire/pipewire.conf.d/
COPY 10-wp-snapcast.conf /etc/wireplumber/wireplumber.conf.d/

# Setup run directory
RUN mkdir /app/ledfx && chmod 777 /app/ledfx

# Setup user
RUN adduser -D -h /app ledfx
ENV HOME=/app/ledfx

# Keep ENV between services
ENV S6_KEEP_ENV=1

# Service options
ENV PIPEWIRE_RUNTIME_DIR=/tmp
ENV PIPEWIRE_OPTS=""
ENV WIREPLUMBER_OPTS=""
ENV SNAPCAST_OPTS=""
ENV LEDFX_OPTS=""

ENTRYPOINT ["/init"]
 