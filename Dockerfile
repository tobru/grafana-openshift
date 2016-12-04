FROM centos:7
MAINTAINER Erik Jacobs <erikmjacobs@gmail.com>

USER root
EXPOSE 3000

ENV GRAFANA_VERSION="4.0.1" \
    GRAFANA_BUILD="1480694114" \
    GRAFANA_PLUGINS="/var/lib/grafana/plugins"

ADD root /
RUN yum -y install https://grafanarel.s3.amazonaws.com/builds/grafana-"$GRAFANA_VERSION"-"$GRAFANA_BUILD".x86_64.rpm && \
    yum -y install wget unzip && \
    yum clean all && \
    wget https://github.com/hawkular/hawkular-grafana-datasource/archive/release.zip -O hawkular-grafana-datasource-release.zip && \
    unzip hawkular-grafana-datasource-release.zip && \
    mkdir ${GRAFANA_PLUGINS}/hawkular && \
    cp -R hawkular-grafana-datasource-release/dist/* ${GRAFANA_PLUGINS}/hawkular

COPY run.sh /usr/share/grafana/
RUN /usr/bin/fix-permissions /usr/share/grafana \
    && /usr/bin/fix-permissions /etc/grafana \
    && /usr/bin/fix-permissions /var/lib/grafana \
    && /usr/bin/fix-permissions /var/log/grafana 

WORKDIR /usr/share/grafana
ENTRYPOINT ["./run.sh"]
