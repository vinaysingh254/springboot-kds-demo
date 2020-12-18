FROM openjdk:8-alpine

ARG JAR_FILE=/target/springboot-kds-demo-1.0-SNAPSHOT.jar

WORKDIR /opt/app

COPY ${JAR_FILE} springboot-kds.jar

ENTRYPOINT ["java", "-jar", "springboot-kds.jar"]