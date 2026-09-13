FROM maven:4.0.0-rc-5-sapmachine-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build ./app/target/*.jar ./app.jar

ARG EUREKA_SERVER=localhost
ARG KEYCLOAK_SERVER=localhost
ARG KEYCLOAK_PORT=8081


ENTRYPOINT java -jar app.jar