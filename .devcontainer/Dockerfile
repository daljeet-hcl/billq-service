# This Dockerfile is used by devcontainer.json to build the dev environment
# It extends the Microsoft Java devcontainer image with additional tools
FROM mcr.microsoft.com/devcontainers/java:1-25-bullseye AS builder

# Install additional development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*  
    # remove apt cache to reduce image size

# Create non-root user if not already present
# (the base image already has vscode user, but we ensure proper permissions)
RUN usermod -aG sudo vscode

# Set working directory
WORKDIR /workspace

# Copy the pom.xml and source code
COPY pom.xml .

#keep a cache for all dependencies, so that they are not downloaded again if the pom.xml has not changed 
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B

COPY src ./src

# Build and extract the layers for better caching and smaller updates
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests -B 


# ---------------------------------------

# Stage 2: Runtime stage
FROM eclipse-temurin:25-jre-alpine

# Create a non-privileged user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Set the working directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /workspace/target/*.jar app.jar

# Modern JVM Optimizations
# 1. RAMPercentage: Don't hardcode -Xmx. Let the JVM auto-scale based on Container limits.
# 2. CDS: Speeds up startup time by caching class metadata.
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+UseParallelGC  -Xshare:on"

#Dockerfile best practices: Expose only the necessary port and use ENTRYPOINT for better signal handling and compatibility with Docker's runtime.
EXPOSE 8083

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]