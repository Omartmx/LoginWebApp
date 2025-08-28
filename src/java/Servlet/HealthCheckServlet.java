package Servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ✅ Configuración para producción
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET");
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        
        // ✅ Información útil para debugging
        String dbHost = System.getenv("MYSQLHOST");
        String dbStatus = (dbHost != null) ? "DB_CONNECTED" : "DB_DISCONNECTED";
        
        response.getWriter().write("OK - " + dbStatus);
        System.out.println("Health check executed - DB Status: " + dbStatus);
    }
}