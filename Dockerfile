FROM openjdk:8-slim

ARG CONTRAST_AGENT_VERSION=3.7.9.17038
ENV APP_VERSION=1.5.4
RUN mkdir /opt/app
## create jar by running mvn -DskipTests=true package
ADD target/spring-petclinic-$APP_VERSION.jar /opt/app

## Contrast configuration template
# /opt/contrast this could be a local VOLUME as well
# networked volumes not recommended
RUN mkdir /opt/contrast
ADD contrast_security.yaml /opt/contrast
ADD https://repo1.maven.org/maven2/com/contrastsecurity/contrast-agent/$CONTRAST_AGENT_VERSION/contrast-agent-$CONTRAST_AGENT_VERSION.jar /opt/contrast/contrast.jar

ENV CONTRAST__OPTS="-javaagent:/opt/contrast/contrast.jar -Dcontrast.config.path=/opt/contrast/contrast_security.yaml"
ENV CONTRAST__SERVER__ENVIRONMENT="development"
ENV CONTRAST__APPLICATION__VERSION=$APP_VERSION
## Set these using the orchestrator services, for instance k8s secretsmap
ENV CONTRAST__API__URL=""
ENV CONTRAST__API__USER_NAME=""
ENV CONTRAST__API__API_KEY=""
ENV CONTRAST__API__SERVICE_KEY=""

## Enable agent
# ENV JAVA_TOOL_OPTIONS=$CONTRAST__OPTS
## End Contrast configuration template

ENTRYPOINT java -Dserver.port=8080 -jar /opt/app/spring-petclinic-$APP_VERSION.jar
EXPOSE 8080