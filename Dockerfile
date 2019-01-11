# Generated by IBM TransformationAdvisor
# Fri Jan 11 14:32:18 UTC 2019


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY ./binary/application/* /config/dropins/
RUN mkdir /config/lib
COPY ./binary/lib/* /config/lib/
RUN ls /config/lib
RUN ls opt/ibm/wlp/usr/servers/defaultServer
RUN ls /usr/shared

#FEATURES: Install any features that are required
USER root
RUN apt-get update && apt-get dist-upgrade -y \
&& rm -rf /var/lib/apt/lists/*
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense \
	jsp-2.3 \
	servlet-3.1 \
	jdbc-4.2; exit 0


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi
