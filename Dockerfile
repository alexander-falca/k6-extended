FROM golang:1.17-alpine AS builder
RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build v0.36.0 --with github.com/dgzlopes/xk6-notification@latest --with github.com/alexander-falca/xk6-prometheus@latest --with github.com/grafana/xk6-output-prometheus-remote@latest

FROM alpine:3.13
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=builder /go/k6 /usr/bin/k6

USER 12345
WORKDIR /home/k6
ENTRYPOINT ["k6"]
