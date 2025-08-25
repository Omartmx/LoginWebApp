FROM tomcat:9.0.108-jre17
COPY ./web/ /usr/local/tomcat/webapps/ROOT/
EXPOSE 8080
CMD ["catalina.sh", "run"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
RUN echo "=== ESTRUCTURA FINAL ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== WEB-INF ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/ && \
    echo "=== CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No hay clases"