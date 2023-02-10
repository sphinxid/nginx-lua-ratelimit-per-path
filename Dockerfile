FROM fabiocicerchia/nginx-lua:1.23.3-alpine3.17.1-compat

# add lua-cjson
RUN apk add gcc musl-dev coreutils curl wget \
    && luarocks install lua-cjson

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf