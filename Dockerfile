FROM tomcat:9.0.108-jre17

COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# DEBUG: Verificar si las clases existen
RUN echo "=== BUSCANDO CLASES ===" && \
    find /usr/local/tomcat/webapps/ROOT/WEB-INF/classes -name "*.class" 2>/dev/null || echo "NO hay clases .class"

EXPOSE 8080
CMD ["catalina.sh", "run"]