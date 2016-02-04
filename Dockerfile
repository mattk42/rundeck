# Dockerfile for rundeck
# https://github.com/jjethwa/rundeck
# Bump to 2.6.2

FROM debian:jessie

MAINTAINER Jordan Jethwa

ENV DEBIAN_FRONTEND noninteractive
ENV SERVER_URL https://localhost:4443

RUN apt-get -qq update && apt-get -qqy upgrade && apt-get -qqy install --no-install-recommends bash supervisor procps sudo ca-certificates openjdk-7-jre-headless openssh-client pwgen curl git wget && apt-get clean

ADD content/ /

ADD http://dl.bintray.com/rundeck/rundeck-deb/rundeck-2.6.2-1-GA.deb /tmp/rundeck.deb
RUN dpkg -i /tmp/rundeck.deb && rm /tmp/rundeck.deb
RUN chown rundeck:rundeck /tmp/rundeck
RUN chmod u+x /opt/run
RUN mkdir -p /var/lib/rundeck/.ssh
RUN chown rundeck:rundeck /var/lib/rundeck/.ssh
RUN wget -O /var/lib/rundeck/libext/rundeck-slack-incoming-webhook-plugin-0.4.jar.gz https://github.com/higanworks/rundeck-slack-incoming-webhook-plugin/releases/download/v0.4.dev/rundeck-slack-incoming-webhook-plugin-0.4.jar.gz
RUN wget -O /var/lib/rundeck/libext/rundeck-s3-log-plugin-1.0.0.jar https://github.com/rundeck-plugins/rundeck-s3-log-plugin/releases/download/v1.0.0/rundeck-s3-log-plugin-1.0.0.jar

# Supervisor
RUN mkdir -p /var/log/supervisor && mkdir -p /opt/supervisor
RUN chmod u+x /opt/supervisor/rundeck

EXPOSE 4440

VOLUME  ["/etc/rundeck", "/var/rundeck", "/var/lib/rundeck", "/var/log/rundeck"]

# Start Supervisor
ENTRYPOINT ["/opt/run"]
