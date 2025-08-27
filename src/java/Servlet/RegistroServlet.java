package Servlet;

import java.sql.ResultSet;
import conexion.Conexion;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ RegistroServlet recibió petición");
        
        // Testear conexión primero
        if (!testConnection()) {
            response.sendRedirect("registro.jsp?error=No se pudo conectar a la base de datos");
            return;
        }

        // 1️⃣ Capturar datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Datos: " + nombre + " " + apellido + " " + email);

        Connection conn = null;
        try {
            conn = Conexion.getConexion();
            
            // 2️⃣ Verificar si el email ya existe
            String checkSql = "SELECT * FROM usuarios WHERE email=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // ❌ Usuario ya existe
                System.out.println("❌ Usuario ya registrado: " + email);
                response.sendRedirect("registro.jsp?error=Usuario ya registrado");
            } else {
                // 3️⃣ Insertar nuevo usuario
                String insertSql = "INSERT INTO usuarios (nombre, apellido, email, password) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(insertSql);
                ps.setString(1, nombre);
                ps.setString(2, apellido);
                ps.setString(3, email);
                ps.setString(4, password);
                ps.executeUpdate();

                System.out.println("✅ Usuario registrado: " + email);
                response.sendRedirect("registro.jsp?success=Usuario registrado correctamente");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Excepción en registro: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("registro.jsp?error=Error en el registro: " + e.getMessage());
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                System.out.println("Error cerrando conexión: " + e.getMessage());
            }
        }
    }
    
    // ✅ MÉTODO testConnection
    private boolean testConnection() {
        try {
            Connection conn = Conexion.getConexion();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Conexión exitosa a la BD");
                conn.close();
                return true;
            }
        } catch (Exception e) {
            System.out.println("❌ Error en conexión: " + e.getMessage());
        }
        return false;
    }
}