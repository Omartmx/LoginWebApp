FROM tomcat:9.0-jre17

# Copiar el WAR a Tomcat
COPY ./target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Puerto para Render
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Comando de inicio
CMD ["catalina.sh", "run"]

# Agrega un comentario al final
# Redeploy: $(date)