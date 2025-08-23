FROM tomcat:9.0-jre17

# Copiar la carpeta web/ (que contiene tus JSPs y WEB-INF)
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar las clases compiladas (si las tienes en build/ o dist/)
COPY ./build/web/WEB-INF/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "Classes not found, skipping"
COPY ./dist/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "Dist not found, skipping"

# Si no hay clases compiladas, copiar el código fuente para compilar después
COPY ./src/ /tmp/src/ 2>/dev/null || echo "Source not found, skipping"

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]