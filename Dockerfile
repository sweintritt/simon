FROM golang:1.10.3-stretch

LABEL MAINTAINER="Programm Eins <programm.eins@gmail.com>"

ARG BINDIR="/opt/simon"

ADD build/ $BINDIR/

# ENV SIMON_PORT

WORKDIR $BINDIR

CMD ["./simon"]
