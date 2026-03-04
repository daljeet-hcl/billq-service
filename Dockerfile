# Stage 1: Build stage
FROM maven:3.9-eclipse-temurin-25-alpine AS builder

# Set the working directory
WORKDIR /build

# Copy the pom.xml and source code
COPY pom.xml .

#keep a cache for all dependencies, so that they are not downloaded again if the pom.xml has not changed 
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B

COPY src ./src

# Build and extract the layers for better caching and smaller updates
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests -B 


# Stage 2: Runtime stage
FROM eclipse-temurin:25-jre-alpine

# Create a non-privileged user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Set the working directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /build/target/*.jar app.jar

# Modern JVM Optimizations
# 1. RAMPercentage: Don't hardcode -Xmx. Let the JVM auto-scale based on Container limits.
# 2. CDS: Speeds up startup time by caching class metadata.
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseParallelGC  -Xshare:on"

#Dockerfile best practices: Expose only the necessary port and use ENTRYPOINT for better signal handling and compatibility with Docker's runtime.
EXPOSE 8083

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
