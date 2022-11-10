# syntax=docker/dockerfile:1

FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 AS builder
ENV LANGUAGE='en_US:en'
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package


FROM registry.access.redhat.com/ubi8/openjdk-17:1.14
ENV LANGUAGE='en_US:en'

RUN curl -L -o /opt/dd-java-agent.jar 'https://dtdg.co/latest-java-tracer'

COPY --from=builder --chown=185 app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=builder --chown=185 app/target/quarkus-app/*.jar /deployments/
COPY --from=builder --chown=185 app/target/quarkus-app/app/ /deployments/app/
COPY --from=builder --chown=185 app/target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 185
ENV JAVA_TOOL_OPTIONS="-javaagent:/opt/dd-java-agent.jar"
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"
