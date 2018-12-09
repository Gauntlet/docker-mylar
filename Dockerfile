FROM lsiobase/alpine.python:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MYLAR_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	comictagger \
	configparser \
	tzlocal && \
 echo "**** install app ****" && \
 if [ -z ${MYLAR_COMMIT+x} ]; then \
	MYLAR_COMMIT=$(curl -sX GET https://api.github.com/repos/evilhero/mylar/commits/master \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
   /app/mylar && \
 curl -o \
 /tmp/mylar.tar.gz -L \
	"https://github.com/evilhero/mylar/archive/${MYLAR_COMMIT}.tar.gz" && \
 tar xf \
 /tmp/mylar.tar.gz -C \
	/app/mylar --strip-components=1 && \
 echo "**** cleanup ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090
