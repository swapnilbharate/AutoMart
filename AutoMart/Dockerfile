# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM tomcat:9.0-jre8-temurin
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Deploy as ROOT.war to serve at the root (/) path
COPY --from=build /app/target/AutoMart.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
