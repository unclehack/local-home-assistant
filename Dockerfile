FROM alpine:latest AS brands-build
RUN apk add git rsync rsvg-convert optipng jq bash fdupes coreutils pngquant
COPY move_shrunk.sh /
RUN git clone https://github.com/home-assistant/brands.git
RUN cd brands; \
    find . -type f -name '*.png' -print0 | xargs -0 -P "$(nproc)" nice -n19 pngquant --skip-if-larger --ext .png.new --speed 1; \
    ../move_shrunk.sh; \
    ./scripts/build.sh; \
    cd build; \
    bash -c 'fdupes -r -1 . | while read line; do master=""; \
       for file in ${line[*]}; do if [ "x${master}" == "x" ]; \
       then master=$file; else ln -rsf "${master}" "${file}"; fi; done; done'

FROM ghcr.io/home-assistant/home-assistant:stable
COPY replace_brands_url.sh /root/replace_brands_url.sh
RUN /root/replace_brands_url.sh
COPY --from=brands-build brands/build/ /usr/local/lib/python3.13/site-packages/hass_frontend/frontend_latest/brands
