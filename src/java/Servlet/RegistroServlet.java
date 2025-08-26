package Servlet;

import java.sql.ResultSet;
import conexion.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Capturar datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("✅ RegistroServlet recibió petición");
        System.out.println("Datos: " + nombre + " " + apellido + " " + email);

        try {
            Connection conn = Conexion.getConexion();
            
            // Debug: verificar si la conexión es nula
            if (conn == null) {
                System.out.println("❌ La conexión es NULL");
                request.setAttribute("mensaje", "Error de conexión a la base de datos");
            } else {
                System.out.println("✅ Conexión establecida: " + conn.toString());
                
                // 2️⃣ Verificar si el email ya existe
                String checkSql = "SELECT * FROM usuarios WHERE email=?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setString(1, email);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    // ❌ Usuario ya existe
                    System.out.println("❌ Usuario ya registrado: " + email);
                    request.setAttribute("mensaje", "❌ Usuario ya registrado.");
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
                    request.setAttribute("mensaje", "✅ Usuario registrado correctamente.");
                }
                conn.close();
            }
            
        } catch (Exception e) {
            System.out.println("❌ Excepción en conexión: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "⚠️ Error: " + e.getMessage());
        }

        // 4️⃣ Volver a la misma página (registro.jsp) con el mensaje
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }
}