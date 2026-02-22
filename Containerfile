FROM registry.access.redhat.com/ubi8/ubi-init:latest

LABEL maintainer="fatherlinux <scott.mccarty@crunchtools.com>"
LABEL description="UBI 8 base image with Apache httpd, mod_fcgid, Perl, and MariaDB for Request Tracker"

# Register with RHSM to access full RHEL repos
RUN --mount=type=secret,id=activation_key \
    --mount=type=secret,id=org_id \
    if [ -f /run/secrets/activation_key ] && [ -f /run/secrets/org_id ]; then \
        subscription-manager register \
            --activationkey="$(cat /run/secrets/activation_key)" \
            --org="$(cat /run/secrets/org_id)" && \
        subscription-manager attach --auto; \
    fi

RUN yum install -y \
    httpd \
    mod_fcgid \
    perl \
    mariadb-server \
    mariadb \
    crontabs \
    cronie \
    iputils \
    net-tools \
    && yum clean all

# Unregister to avoid leaking entitlements in the image
RUN subscription-manager unregister 2>/dev/null || true

RUN systemctl enable httpd mariadb
RUN systemctl disable systemd-update-utmp.service

ENTRYPOINT ["/sbin/init"]
CMD ["/sbin/init"]
