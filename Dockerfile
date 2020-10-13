FROM 0x01be/minetest:build as build

FROM 0x01be/xpra

COPY --from=build /usr/local/bin/minetest /usr/bin/
COPY --from=build /usr/local/share/minetest /usr/share/minetest

USER root
RUN apk add --no-cache --virtual minitest-runtime-dependencies \
    irrlicht \
    bzip2 \
    libpng \
    jpeg \
    libxxf86vm \
    mesa \
    sqlite \
    libogg \
    libvorbis \
    openal-soft \
    libcurl \
    freetype \
    zlib \
    gmp \
    jsoncpp \
    luajit \
    postgresql-libs \
    ca-certificates \
    mesa-dri-swrast

USER xpra

ENV COMMAND "minetest"

