# Usage: FROM [image name]
FROM debian

# Usage: MAINTAINER [name]
MAINTAINER weezhard

# Variables
ENV ELASTICSEARCH_VERSION 2.2.0

# Install openjdk
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y -q wget openjdk-8-jre

# Install elasticsearch
RUN wget -q https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ELASTICSEARCH_VERSION/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz -O /opt/elasticsearch.tar.gz && \
    cd /opt && tar -xzvf elasticsearch.tar.gz && \
    mv /opt/elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch

RUN /opt/elasticsearch/bin/plugin install mobz/elasticsearch-head
RUN /opt/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf


# Clean apt
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /opt/elasticsearch.tar.gz

# Adduser elasticsearch
RUN useradd elasticsearch
RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch

USER elasticsearch

RUN mkdir /opt/elasticsearch/logs
RUN mkdir /opt/elasticsearch/data
COPY conf/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

COPY conf/elasticsearch-entrypoint /

# Add VOLUMEs logs and data
VOLUME  ["/opt/elasticsearch/data", "/opt/elasticsearch/logs"]

# Expose and Startup
EXPOSE 9200 9300

ENTRYPOINT ["/elasticsearch-entrypoint"]
