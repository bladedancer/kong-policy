FROM golang:1.16 as builder

RUN mkdir -p /build

WORKDIR /build

COPY go.mod .
COPY go.sum .

ARG GO_PROXY
ENV GO_PROXY=${GO_PROXY}

RUN go mod download

# Copy necessary files
ADD . .

RUN ls -l
RUN rm -rf bin
# TODO: TAGS
#RUN --mount=type=cache,target=/root/.cache/go-build \
#RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -x -o bin/policyserver ./main.go
RUN make build

# Create non-root user
RUN addgroup axway && adduser --system axway --ingroup axway
RUN chown -R axway:axway bin/policyserver
USER axway

# Base image
FROM scratch

# Copy binary and user from previous build step
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /build/bin/policyserver /root/policyserver
COPY --from=builder /etc/passwd /etc/passwd
USER axway

ENTRYPOINT ["/root/policyserver"]
