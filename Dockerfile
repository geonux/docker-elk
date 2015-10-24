FROM java:8
MAINTAINER Vincent Gaudissart (gaudissart@gmail.com)

RUN apt-get update
RUN apt-get install -y supervisor wget

WORKDIR /opt

# Download ELK
RUN wget https://download.elastic.co/logstash/logstash/logstash-1.5.4.tar.gz
RUN wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.2.tar.gz
RUN wget https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz

# Extract files
RUN ls *.tar.gz | xargs -i tar -zxf {}
RUN rm *.tar.gz

RUN mv logstash-*/ logstash/ && mv elasticsearch-*/ elasticsearch/ && mv kibana-*/ kibana/

RUN elasticsearch/bin/plugin -install mobz/elasticsearch-head

ADD assets/supervisor/ /etc/supervisor/conf.d/
ADD assets/logstash_simple.conf /opt/logstash/conf/logstash_simple.conf

EXPOSE 5000 5601 9200

CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
