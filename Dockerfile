# This image provides an environment for building and running Go applications.

FROM openshift/base-centos7

MAINTAINER SoftwareCollections.org <sclorg@redhat.com>



ENV GO_MINOR_VERSION=7 \
    GO_PATCH_VERSION=3

ENV GO_VERSION=1.${GO_MINOR_VERSION} \
    GOPATH=$HOME/go \
    GOBIN=$HOME/go/bin \
    SOURCE=$HOME/go/src/main \
    PATH=$PATH:$HOME/go/bin:/usr/local/go/bin \
    STI_SCRIPTS_PATH=

LABEL io.k8s.description="Platform for building and running Go applications" \
      io.k8s.display-name="Go ${GO_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,go,go1${GO_MINOR_VERSION}"

# Install Go toolchain
RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="mercurial" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -L https://storage.googleapis.com/golang/go${GO_VERSION}${GO_PATCH_VERSION:+.}${GO_PATCH_VERSION}.linux-amd64.tar.gz | \
        tar -xz -C /usr/local)

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/ /usr/local/s2i

USER 1001

EXPOSE 8080

# Set the default CMD to print the usage of the language image
CMD ["usage"]
