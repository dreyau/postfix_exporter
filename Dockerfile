FROM golang as builder
ADD . /go/src/github.com/kumina/postfix_exporter
WORKDIR /go/src/github.com/kumina/postfix_exporter
RUN apt-get update -qq && apt-get install -qqy \
  build-essential \
  libsystemd-dev
RUN go get -v ./...
RUN go build -ldflags "-linkmode external -extldflags -static"

FROM busybox:latest

WORKDIR /
COPY --from=builder /go/src/github.com/kumina/postfix_exporter/postfix_exporter .

ENTRYPOINT ["/postfix_exporter"]
EXPOSE 9154
