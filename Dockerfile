FROM openresty/openresty:xenial

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean
RUN apt-get update \
    && apt-get install -y \
       git \
    && mkdir /src \
    && cd /src \
    && git config --global url."https://".insteadOf git:// \
    && luarocks install lua-resty-redis \
    && luarocks install lua-resty-lock \
    && git clone https://github.com/steve0511/resty-redis-cluster.git \
    && cd resty-redis-cluster/ \
    && luarocks make \
    && gcc src/redis_slot.c src/redis_slot.h -fPIC -shared -o /usr/local/openresty/luajit/lib/lua/5.1/librestyredisslot.so \
    && rm -Rf /src
