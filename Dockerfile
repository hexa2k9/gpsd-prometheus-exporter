FROM debian:bookworm-slim

RUN set -eux; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    python3-gps \
    python3-packaging \
    python3-prometheus-client \
  ; \
  find /var/lib/apt/lists -mindepth 1 -delete

WORKDIR /app
COPY . /app

ENV GEOPOINT_LON=0.00
ENV GEOPOINT_LAT=0.00

CMD [ "./entrypoint.sh" ]
