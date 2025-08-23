FROM tomcat:9.0-jre17

# Copiar la carpeta web/
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# DEBUG: Verificar qué se copió
RUN echo "=== ESTRUCTURA COMPLETA ===" && \
    find /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ -name "*.class" 2>/dev/null || echo "No se encontraron clases .class"

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]