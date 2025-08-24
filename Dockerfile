FROM tomcat:9.0.108-jre17

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY ./dist/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Verificar que el WAR se copió
RUN ls -la /usr/local/tomcat/webapps/

# Verificar contenido del WAR
RUN unzip -l /usr/local/tomcat/webapps/ROOT.war | head -20

EXPOSE 8080
CMD ["catalina.sh", "run"]