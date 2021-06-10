FROM alpine:3.8 as protoc_builder
RUN apk add --no-cache build-base curl automake autoconf libtool git zlib-dev

# 本镜像使用旧的micro, 已弃用consul
# 参考地址如下:
#
# https://micro.mu/blog/2019/10/04/deprecating-consul.html
RUN apk add --no-cache go
ENV GOPATH=/go \
        PATH=/go/bin/:$PATH

ENV GRPC_VERSION=1.16.0 \
        PROTOBUF_VERSION=3.6.1 \
        OUTDIR=/out

RUN mkdir -p /protobuf && \
        curl -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz --strip-components=1 -C /protobuf
# 编译protobuf
RUN cd /protobuf && \
        autoreconf -f -i -Wall,no-obsolete && \
        ./configure --prefix=/usr --enable-static=no && \
        make -j2 && make install

RUN cd /protobuf && \
        make install DESTDIR=${OUTDIR}

RUN go get -u -v -ldflags '-w -s' \
        github.com/Masterminds/glide \
        github.com/golang/protobuf/protoc-gen-go \
        github.com/micro/protoc-gen-micro \
        && install -c ${GOPATH}/bin/protoc-gen* ${OUTDIR}/usr/bin/

# 二次重构, 仅获取bin文件
FROM alpine:3.8
RUN apk add --no-cache libstdc++
COPY --from=protoc_builder /out/ /

ENTRYPOINT []