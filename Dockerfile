FROM tomcat:9.0-jre17

# Copiar TODO el proyecto a Tomcat
COPY . /usr/local/tomcat/webapps/ROOT/

# Puerto que Render usa
EXPOSE 8080

# Health check para Render
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Iniciar Tomcat
CMD ["catalina.sh", "run"]