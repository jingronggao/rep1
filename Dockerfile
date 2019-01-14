# Generated by IBM TransformationAdvisor
# Mon Jan 14 13:00:41 EST 2019


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY Dockerfile ./binary/application/* /config/apps/
RUN mkdir /config/lib
COPY ./binary/lib/* /config/lib/
USER root
RUN ls /config/../
RUN ls /config/../..
RUN mkdir -p /config/../../shared/config/lib/global
RUN ls /config/../../shared/config/lib/global/
RUN cp /config/lib/* /config/../../shared/config/lib/global/
RUN chmod 755 /config/../../shared/config/lib/global/*
Run ls -la /opt/ibm/wlp/usr/shared/config/lib/global/
RUN ls -la /config/../../shared/config/lib/global/
#FEATURES: Install any features that are required
USER root
RUN apt-get update && apt-get dist-upgrade -y \
&& rm -rf /var/lib/apt/lists/* 
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense defaultServer


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi

USER 1001
