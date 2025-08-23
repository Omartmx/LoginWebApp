FROM tomcat:9.0-jre17

# Crear directorio principal
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copiar carpetas con espacios (usando comillas y escape correcto)
COPY "Web Pages/" /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || echo "Web Pages not found, skipping"
COPY "Source Packages/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "Source Packages not found, skipping"
COPY "META-INF/" /usr/local/tomcat/webapps/ROOT/META-INF/ 2>/dev/null || echo "META-INF not found, skipping"
COPY "WEB-INF/" /usr/local/tomcat/webapps/ROOT/WEB-INF/ 2>/dev/null || echo "WEB-INF not found, skipping"

# Si no tienes WEB-INF, crea una básica
RUN if [ ! -d "/usr/local/tomcat/webapps/ROOT/WEB-INF" ]; then \
    mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF && \
    echo '<?xml version="1.0" encoding="UTF-8"?><web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0"></web-app>' > /usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml; \
fi

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]