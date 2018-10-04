# Generated by IBM TransformationAdvisor
# Thu Oct 04 19:00:16 UTC 2018


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

ADD http://9.26.42.227:9666/com/ibm/ta/modresorts/1.0/modresorts-1.0.war ./
RUN pwd
RUN ls -la ./

#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
#COPY ./binary/application/* /config/dropins/
COPY ../../../../../modresorts-1.0.war /config/dropins/
RUN ls -la /config/dropins/


#FEATURES: Install any features that are required
RUN apt-get update && apt-get dist-upgrade -y \
&& rm -rf /var/lib/apt/lists/*
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense \
	jsp-2.3 \
	servlet-3.1; exit 0


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi
