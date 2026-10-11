# Stage 1: Build FraudGuard with Maven and Eclipse Temurin JDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy configuration and source files
COPY pom.xml .
COPY src ./src
COPY database ./database

# Build and package WAR (skip tests to optimize cloud build time)
RUN mvn clean package -DskipTests

# Stage 2: Production Runtime with Apache Tomcat 10.1 (Jakarta EE 10 / Servlet 6.0)
FROM tomcat:10.1-jdk21-temurin
WORKDIR /usr/local/tomcat

# Clean default web applications for security and minimal footprint
RUN rm -rf webapps/*

# Deploy FraudGuard as ROOT.war so it serves directly at root (/)
COPY --from=builder /app/target/fraudguard.war webapps/ROOT.war

# Disable Tomcat shutdown port 8005 so Render only sees the HTTP port
RUN sed -i 's/<Server port="8005"/<Server port="-1"/' conf/server.xml

# Expose default Tomcat HTTP port
EXPOSE 8080

# Dynamically adapt Tomcat port to Render's dynamic PORT environment variable
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" conf/server.xml && exec catalina.sh run"]
