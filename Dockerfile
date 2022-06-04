FROM --platform=$BUILDPLATFORM golang as builder

ARG TARGETOS
ARG TARGETARCH
ARG VERSION
ARG BUILD_DATE

COPY . /src

WORKDIR /src

RUN env GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 GOPROXY=https://goproxy.cn,direct go mod download && \
  export GIT_COMMIT=$(git rev-parse HEAD) && \
  export GIT_DIRTY=$(test -n "`git status --porcelain`" && echo "+CHANGES" || true) && \
  go env -w GO111MODULE=on && \
  env GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 \
    go build -o k8s-mutate-image-and-policy-webhook \
    -ldflags "-X github.com/sqooba/go-common/version.GitCommit=${GIT_COMMIT}${GIT_DIRTY} \
              -X github.com/sqooba/go-common/version.BuildDate=${BUILD_DATE} \
              -X github.com/sqooba/go-common/version.Version=${VERSION}" \
    .

FROM --platform=$BUILDPLATFORM knative-dev-registry.cn-hangzhou.cr.aliyuncs.com/distroless/base

COPY --from=builder /src/k8s-mutate-image-and-policy-webhook /k8s-mutate-image-and-policy-webhook

USER nobody

ENTRYPOINT ["/k8s-mutate-image-and-policy-webhook"]
EXPOSE 8443
