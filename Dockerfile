FROM arm32v6/alpine

ENV MINETEST_GAME_VERSION master

RUN apk add --no-cache --virtual minitest-build-dependencies \
    git \
    build-base \
    cmake \
    irrlicht-dev \
    bzip2-dev \
    libpng-dev \
    jpeg-dev \
    libxxf86vm-dev \
    mesa-dev \
    sqlite-dev \
    libogg-dev \
    libvorbis-dev \
    openal-soft-dev \
    curl-dev \
    freetype-dev \
    zlib-dev \
    gmp-dev \
    jsoncpp-dev \
    postgresql-dev \
    luajit-dev \
    ca-certificates

RUN git clone --depth=1 -b ${MINETEST_GAME_VERSION} https://github.com/minetest/minetest.git /usr/src/minetest
RUN git clone --depth=1 -b ${MINETEST_GAME_VERSION} https://github.com/minetest/minetest_game.git /usr/src/minetest/games/minetest_game 
RUN git clone --recursive https://github.com/jupp0r/prometheus-cpp/ /usr/src/prometheus-cpp

WORKDIR /usr/src/prometheus-cpp/build
RUN cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_BUILD_TYPE=Release \
     -DENABLE_TESTING=0
RUN make
RUN make install

WORKDIR /usr/src/minetest/build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SERVER=TRUE \
    -DENABLE_PROMETHEUS=TRUE \
    -DBUILD_UNITTESTS=FALSE \
    -DBUILD_CLIENT=TRUE \
    ..
RUN make
RUN make install

