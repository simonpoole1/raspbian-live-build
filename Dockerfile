FROM ubuntu:trusty

MAINTAINER Luis Gustavo S. Barreto <gustavosbarreto@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y live-build make parted \
                       qemu-user-static qemu-utils qemu-system-arm

WORKDIR /tmp/

ADD . /tmp/raspbian-live-build

WORKDIR /tmp/raspbian-live-build

CMD ["mount", "binfmt_misc", "-t", "binfmt_misc", "/proc/sys/fs/binfmt_misc"]
CMD ["update-binfmts", "--enable"]
CMD ["make"]

