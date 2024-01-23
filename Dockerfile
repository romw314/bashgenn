# Use bash:5.2-alpine3.19 for the Alpine Linux variants (see docker-build.sh for tag info)
ARG BASE=debian:bullseye

FROM $BASE

ARG BASHGENN_VERSION=v1
# Use alpine for the Alpine Linux variants
ARG VARIANT=debian

RUN install -d /usr/local/share/bashgenn

ENV IMG_VARIANT=$VARIANT

RUN set -eux; \
	case $IMG_VARIANT in \
		alpine) apk update && apk add coreutils;; \
		debian) :;; \
		*) echo "Unknown variant"; exit 1;; \
	esac

RUN install -d /etc/bashgenn

RUN echo -e "[strict=err]\n[ireq=false]" > /etc/bashgenn/bgconf

COPY bashgenn /usr/local/share/bashgenn/bashgenn.bash

RUN ln -s /usr/local/share/bashgenn/bashgenn.bash /usr/local/bin/bashgenn

CMD ["bashgenn"]
