# Generated by IBM TransformationAdvisor
# Fri Jan 25 10:41:46 UTC 2019


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

USER root
#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY Dockerfile ./binary/application/* /config/apps/
RUN find / -name Dockerfile
RUN mkdir /config/lib
RUN ls -la /config/apps
COPY ./binary/lib/* /config/lib/
RUN mkdir -p /config/../../shared/config/lib/global
RUN cp /config/lib/* /config/../../shared/config/lib/global/
RUN cp /config/apps/Dockerfile /config/../../shared/config/lib/global/
RUN ls /config/../../shared/config/lib/global/
RUN chmod -R 755 /config/../../shared

#FEATURES: Install any features that are required
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
