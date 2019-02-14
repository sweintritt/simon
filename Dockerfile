FROM golang:1.10.3-stretch

LABEL MAINTAINER="Stephan Weintritt <45856463+sweintritt@users.noreply.github.com>"

ARG BINDIR="/opt/simon"

ADD build/ $BINDIR/

# ENV SIMON_PORT

WORKDIR $BINDIR

CMD ["./simon"]
