FROM openjdk:8-jre-alpine
WORKDIR /app
COPY target/*.jar /app/app.jar
ENTRYPOINT ["java","-jar","app.jar"]
EXPOSE 8081


