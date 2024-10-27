# Stage 1: Build the Spring Boot application
FROM maven:latest AS build

# Set the working directory in the container
WORKDIR /app

# Copy pom.xml and download dependencies only, to leverage caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire project and build it
COPY . .
RUN mvn clean package -DskipTests && \
    mv target/*.jar app.jar # Renaming the JAR to a consistent name

# Stage 2: Run the Spring Boot application
FROM openjdk:17-jdk-slim

# Set environment variables
ENV APP_NAME=spring-boot-app \
    APP_PORT=7000

# Create a user to run the application and clean up package cache in a single RUN command
RUN addgroup --system spring && adduser --system --ingroup spring spring

# Use a non-root user for security
USER spring:spring

# Copy the JAR file from the build stage
COPY --from=build /app/app.jar /app/${APP_NAME}.jar

# Expose the application port
EXPOSE ${APP_PORT}
EXPOSE 5432

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/spring-boot-app.jar"]
