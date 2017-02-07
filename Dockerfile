FROM scsb/scsb-base:latest
MAINTAINER Sheik Salahudeen "sheik.sahib@htcinc.com"

# Download the CAS overlay project \
RUN cd / \
    && git clone --depth 1 --single-branch https://github.com/sheiksalahudeen/cas-overlay-template.git cas-overlay \
    && mkdir -p /etc/cas \
    && mkdir -p /etc/cas/services \
    && mkdir -p /etc/cas/config \
    && mkdir -p cas-overlay/bin \
    && cp -f cas-overlay/etc/cas/config/*.* /etc/cas/config;

COPY thekeystore /etc/cas/
COPY bin/*.* cas-overlay/bin/

RUN chmod -R 750 cas-overlay/bin \
    && chmod 750 cas-overlay/mvnw \
    && chmod 750 cas-overlay/build.sh \
    && chmod 750 /opt/jdk1.8.0_51/bin/java;

# Enable if you are using Oracle Java
#	&& chmod 750 /opt/jdk1.8.0_51/jre/bin/java;

EXPOSE 8080 8443

WORKDIR /cas-overlay

ENV JAVA_HOME /opt/jdk1.8.0_51
ENV PATH $PATH:$JAVA_HOME/bin:.

RUN ./mvnw clean package -T 10

CMD ["/cas-overlay/bin/run-cas.sh"]
