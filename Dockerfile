FROM tomcat:9.0-jre17

# Copiar TODO el proyecto
COPY . /usr/local/tomcat/webapps/ROOT/

# DEBUG: Verificar estructura de clases
RUN echo "=== BUSCANDO CLASES ===" && \
    find /usr/local/tomcat/webapps/ROOT/ -name "*.class" | head -20 && \
    echo "=== ESTRUCTURA WEB-INF ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/ && \
    echo "=== ESTRUCTURA CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No existe classes/"

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]