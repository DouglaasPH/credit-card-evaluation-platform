FROM maven:4.0.0-rc-5-sapmachine-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:27-ea-17-oraclelinux9
WORKDIR /app
COPY --from=build ./app/target/*.jar ./app.jar

ARG EUREKA_SERVER=localhost

ENTRYPOINT java -jar app.jar