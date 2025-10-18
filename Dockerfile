# Install some packages we need https://www.keycloak.org/server/containers#_installing_additional_rpm_packages
FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs  \
      openssl \
      gawk \
      sed \
      curl \
      --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak:24.0.5
COPY --from=ubi-micro-build /mnt/rootfs /
COPY custom_entrypoint.sh /custom_entrypoint.sh
ENTRYPOINT ["/custom_entrypoint.sh"]
