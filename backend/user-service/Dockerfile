FROM maven:3.9-amazoncorretto-25 AS build

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline -q -B -DskipTests

COPY src ./src
RUN mvn package -q -DskipTests

FROM amazoncorretto:25-alpine

WORKDIR /app

COPY --from=build /build/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]