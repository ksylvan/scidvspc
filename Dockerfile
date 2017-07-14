# SCID in debian-based docker container.
#
# Using the SCID chess DB implementation here:
# http://scidvspc.sourceforge.net/
#

FROM debian:buster-slim

LABEL maintainer "Kayvan Sylvan <kayvansylvan@gmail.com>"

ADD https://downloads.sourceforge.net/project/scidvspc/source/scid_vs_pc-4.18.tgz /home/scid/
WORKDIR /home/scid
RUN if [ ! -d scid_vs_pc-4.18 ]; then tar xvzf scid_vs_pc-4.18.tgz; fi \
  && cd scid_vs_pc-4.18 \
  && apt-get update \
  && apt-get -y install make g++ tk-dev tcl-dev tk tcl stockfish \
  && ./configure && make install \
  && apt-get remove --purge -y make g++ && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/scid"]
