FROM python:3.13-alpine3.20 AS builder

ADD . /work
WORKDIR /work

RUN set -eux \
  && apk update \
  && apk add musl-dev gcc \
  && pip install virtualenv \
  && virtualenv /opt/virtualenv \
  && /opt/virtualenv/bin/pip install -r requirements.txt \
  && /opt/virtualenv/bin/pip install -r requirements.gps.txt

FROM python:3.13-alpine3.20

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PATH=/opt/virtualenv/bin:${PATH}

RUN set -eux \
  && mkdir -p /work \
  && apk --no-cache upgrade  \
  && apk --no-cache add bash

ADD entrypoint.sh /work
ADD gpsd_exporter.py /work

WORKDIR /work

COPY --from=builder /opt/virtualenv /opt/virtualenv

EXPOSE 9015

CMD [ "bash", "/work/entrypoint.sh" ]
