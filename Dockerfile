FROM docker.io/adoptopenjdk/openjdk11:x86_64-ubi-minimal-jre-11.0.14.1_1

USER root

ARG ARG_MESSAGE_WELCOME='Hello, World'
ENV MESSAGE_WELCOME=${ARG_MESSAGE_WELCOME}

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

USER 1001 

ENTRYPOINT ["java", "-jar", "/app.jar"]
