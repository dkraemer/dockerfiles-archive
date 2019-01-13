##########################################
# Stage 1: Build static portainer binary #
##########################################
# Image portainer/golang-builder doesn't work inside a dockerfile
# (/src is a volume and we can't access it while building)
# so we need to use it's base image (golang:1.10) and tweak it.
FROM golang:1.10 as go-build
ARG BUILD_ARCH=amd64

# Install updates
RUN apt-get update \
 && apt-get upgrade -y --with-new-pkgs

# Download required build scripts from dkraemer/golang-builder and make them executable.
RUN curl -sSL https://raw.githubusercontent.com/dkraemer/golang-builder/master/builder-cross/build.sh -o /build.sh \
 && curl -sSL https://raw.githubusercontent.com/dkraemer/golang-builder/master/builder-cross/build_environment.sh -o /build_environment.sh \
 && chmod -v +x /build*.sh

# Get the code.
RUN git clone https://github.com/dkraemer/portainer.git /portainer \
 && cd /portainer \
 && git checkout 1.20.0

# /build.sh expects the api source in /src.
RUN cp -r /portainer/api /src
WORKDIR /src

# Build the static binary.
ENV BUILD_GOOS=linux
ENV BUILD_GOARCH=${BUILD_ARCH}
RUN /build.sh /src/cmd/portainer

#########################################
# Stage 2: Build the management website #
#########################################
# Since we don't want to install node.js locally run it as a container.
FROM node:10 as node-build
ARG BUILD_ARCH=amd64

# Install updates
RUN apt-get update \
 && apt-get upgrade -y --with-new-pkgs

# Grab a copy of portainer's source.
COPY --from=go-build /portainer /src

# Copy the static binary for distribution.
COPY --from=go-build /src/cmd/portainer/portainer-linux-${BUILD_ARCH} /src/api/cmd/portainer/

# A dummy docker executable is required because grunt runs build/build_in_container.sh (which we don't need).
RUN touch /bin/docker \
 && chmod +x /bin/docker

# Download all website dependencies.
WORKDIR /src
RUN yarn

# Build the distribution.
RUN yarn grunt release:linux:${BUILD_ARCH}

# Fix filenames and permissions.
RUN mv dist/portainer-linux-${BUILD_ARCH} dist/portainer \
 && chown -R 0.0 dist

# Compress binaries using UPX
RUN curl -sSL https://github.com/upx/upx/releases/download/v3.95/upx-3.95-amd64_linux.tar.xz -o upx.tar.xz \
 && tar xavf upx.tar.xz \
 && ./upx-3.95-amd64_linux/upx --best dist/portainer \
 && ./upx-3.95-amd64_linux/upx -t dist/portainer \
 && ./upx-3.95-amd64_linux/upx --best dist/docker \
 && ./upx-3.95-amd64_linux/upx -t dist/docker

##################################
# Stage 3: Build the final image #
##################################
# Our static portainer binary doesn't need a full linux distribution
FROM scratch

# Copy ca certificates (why? got this from portainer/base)
COPY --from=node-build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy required portainer files
COPY --from=node-build /src/dist /

# Setup required volume configuration
VOLUME [ "/data" ]

EXPOSE 9000
ENTRYPOINT [ "/portainer" ]
