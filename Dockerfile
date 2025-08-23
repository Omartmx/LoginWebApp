FROM tomcat:9.0-jre17

# Copiar las carpetas de tu proyecto a la ubicación correcta
COPY ./Web Pages/ /usr/local/tomcat/webapps/ROOT/
COPY ./Source\ Packages/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY ./META-INF/ /usr/local/tomcat/webapps/ROOT/META-INF/
COPY ./WEB-INF/ /usr/local/tomcat/webapps/ROOT/WEB-INF/

# Puerto que Render usa
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Iniciar Tomcat
CMD ["catalina.sh", "run"]