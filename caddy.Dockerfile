FROM caddy:builder AS builder

RUN apk add --no-cache git

RUN git clone https://github.com/fabriziosalmi/caddy-mib.git /caddy-mib

RUN xcaddy build \
    --with github.com/ueffel/caddy-brotli \
    --with github.com/fabriziosalmi/caddy-mib=/caddy-mib

FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy