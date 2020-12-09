#### Sample build using for instance Jenkins build post-step
## docker build -t $POM_ARTIFACTID:$POM_VERSION
## --build-arg APP_NAME=$POM_DISPLAYNAME
## --build-arg APP_VERSION=$POM_VERSION 
## --build-arg CONTRAST__API__URL=$CONTRAST__API__URL
## --build-arg CONTRAST__API__USER_NAME=$CONTRAST__API__USER_NAME
## --build-arg CONTRAST__API__API_KEY=$CONTRAST__API__API_KEY
## --build-arg CONTRAST__API__SERVICE_KEY=$CONTRAST__API__SERVICE_KEY
## /path/to/spring-petclinic/


#### Contrast is enabled by -javaagent:/opt/contrast/contrast.jar
#### For example
## docker run --env-file uat.env $POM_ARTIFACTID:$POM_VERSION


FROM openjdk:8-slim

ARG APP_NAME=Petclinic
ARG APP_VERSION=1.5.4
ENV APP_VERSION ${APP_VERSION}
RUN mkdir -p /opt/app
ADD target/spring-petclinic-$APP_VERSION.jar /opt/app


RUN mkdir -p /opt/contrast
ADD target/lib/contrast.jar /opt/contrast/

ARG CONTRAST__API__URL
ARG CONTRAST__API__USER_NAME
ARG CONTRAST__API__API_KEY
ARG CONTRAST__API__SERVICE_KEY

ENV CONTRAST__API__URL=${CONTRAST__API__URL}
ENV CONTRAST__API__USER_NAME=${CONTRAST__API__USER_NAME}
ENV CONTRAST__API__API_KEY=${CONTRAST__API__API_KEY}
ENV CONTRAST__API__SERVICE_KEY=${CONTRAST__API__SERVICE_KEY}

ENV CONTRAST__APPLICATION__NAME=${APP_NAME}
ENV CONTRAST__AGENT__JAVA__STANDALONE_APP_NAME=${APP_NAME}
ENV CONTRAST__APPLICATION__VERSION=${APP_VERSION}

ENTRYPOINT java -Dserver.port=9999 -jar /opt/app/spring-petclinic-$APP_VERSION.jar
EXPOSE 9999