FROM registry.access.redhat.com/ubi8/ubi-init:latest

LABEL maintainer="fatherlinux <scott.mccarty@crunchtools.com>"
LABEL description="UBI 8 base image with Apache httpd, mod_fcgid, Perl, and MariaDB for Request Tracker"

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

RUN systemctl enable httpd mariadb
RUN systemctl disable systemd-update-utmp.service

ENTRYPOINT ["/sbin/init"]
CMD ["/sbin/init"]
