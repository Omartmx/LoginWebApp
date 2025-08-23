FROM maven:3.8.6-openjdk-17 AS build
COPY . /app
WORKDIR /app
RUN mvn clean compile war:war

FROM tomcat:9.0-jre17
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]